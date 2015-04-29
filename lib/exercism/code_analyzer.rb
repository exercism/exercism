require 'rest-client'
require 'json'
class CodeAnalyzer
  attr_reader :language, :code, :commit_id, :git_rep_info, :user

  def initialize(options = {})
    @language = options[:language]
    @code = options[:code]
    @commit_id = options[:commit_id]
    @git_rep_info = options[:git_rep_info]
    @user = options[:user]
  end

  def run
    "---common---"
  end

  def self.class_exists?(class_name)
    klass = Module.const_get(class_name)
    return klass.is_a?(Class)
    rescue NameError
    return false
  end

  def self.build(options = {})
    options[:language] ||= ""
    if options[:language].strip.empty?
      CodeAnalyzer.new(options)
    else
      klass = options[:language].strip.capitalize
      if class_exists?(klass)
        const_get(klass).new(options)
      else
        CodeAnalyzer.new(options)
      end
    end
  end
end

class Ruby < CodeAnalyzer
  def run
    unless ENV.fetch('RACK_ENV') == "test"
      file_name = "#{settings.root}/rubocop_tmp/test_#{user.id}.rb"
      rubocop_code_file = File.new(file_name, "w+")
      rubocop_code_file.write code
      rubocop_code_file.rewind
      analysis = `rubocop "#{rubocop_code_file.path}"`
      File.delete rubocop_code_file.path
      analysis
    end
  end
end

class Java < CodeAnalyzer
  def run
   projectName = user.username + user.id.to_s + git_rep_info.split('/').last
   xml = "<project>
   <actions/><description/>
   <keepDependencies>false</keepDependencies>
   <properties><com.coravy.hudson.plugins.github.GithubProjectProperty plugin='github@1.11.3'>
   <projectUrl>https://github.com/#{git_rep_info}</projectUrl>
   </com.coravy.hudson.plugins.github.GithubProjectProperty></properties><scm class='hudson.plugins.git.GitSCM' plugin='git@2.3.5'><configVersion>2</configVersion>
   <userRemoteConfigs><hudson.plugins.git.UserRemoteConfig>
    <url>https://github.com/#{git_rep_info}.git</url></hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches><hudson.plugins.git.BranchSpec><name>*/master</name></hudson.plugins.git.BranchSpec></branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class='list'/><extensions/></scm>
    <canRoam>true</canRoam><disabled>false</disabled><blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
    <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding><triggers/>
    <concurrentBuild>false</concurrentBuild><builders>
    <hudson.plugins.sonar.SonarRunnerBuilder plugin='sonar@2.2.1'><project/>
    <properties># required metadata
      sonar.projectKey=#{projectName}
      sonar.projectName=#{projectName}
      sonar.projectVersion=2.0
      # path to source directories (required)
      sonar.sources=src
    </properties>
      <javaOpts/>
    <jdk>(Inherit From Job)</jdk><task/>
    </hudson.plugins.sonar.SonarRunnerBuilder></builders>
    <publishers/><buildWrappers/></project>"

    jobs = RestClient.get 'http://localhost:8080/api/json?tree=jobs[name]', {:content_type => 'application/json'}
    jobs = JSON.parse(jobs)
    jobs_exist = jobs["jobs"].select{|job| job["name"] == projectName}
    new_job_url = "http://localhost:8080/createItem?name=#{projectName}"
    create_job_response = RestClient.post new_job_url, xml, {:content_type => 'application/xml'}  if jobs_exist.empty?
    build_job_response = nil
    if jobs_exist.size > 0 || create_job_response.code == 200
      build_job_response = RestClient.post "http://localhost:8080/job/"+projectName+"/build", {:content_type => 'application/json'}
    end

    if build_job_response.code == 201
      return "http://localhost:8455/dashboard/index/"+projectName
    else
      return "--error--"
    end
  end
end


# p CodeAnalyzer.build({ language: 'java',
#                       code: "",
#                       git_rep_info: 'hanumakanthvvn/sample-java-project' }).run