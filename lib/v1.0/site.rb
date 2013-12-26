class ExercismV1p0 < Sinatra::Base
  get '/' do
    haml :"site/index"
  end
end
