module Dictatious
  class Request
    require "http"

    URL = "https://texttospeech.googleapis.com/v1/text:synthesize"

    attr_reader :word

    def initialize(word)
      @word = word
    end

    def perform
      response = HTTP.auth("Bearer #{ENV["GOOGLE_APPLICATION_TOKEN"]}")
                     .headers("Content-Type" => "application/json; charset=utf-8")
                     .post(URL, body: JSON.generate(params))
      audio_base64 = response.parse["audioContent"]
      audio_mp3    = Base64.decode64(audio_base64)
      path         = File.expand_path("../../data/output/module_2_week_1/#{word}.mp3", __dir__)
      File.open(path, "w+") do |file|
        file.write(audio_mp3)
      end
    end

    def params
      {
        input: { text: word },
        voice: {
          languageCode: "fr-CA",
          name:         "fr-CA-Standard-A",
          ssmlGender:   "FEMALE"
        },
        audioConfig: {
          audioEncoding: "MP3",
          speakingRate:  "0.80"
        }
      }
    end
  end
end
