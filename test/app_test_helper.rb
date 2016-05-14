module AppTestHelper
  def login(user)
    { 'rack.session' => { github_id: user.github_id } }
  end

  def language_tracks_json
    tracks_file = File.expand_path('../fixtures/approvals/tracks.json', __FILE__)
    File.read(tracks_file)
  end
end
