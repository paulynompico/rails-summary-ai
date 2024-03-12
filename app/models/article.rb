require 'rubygems'
require 'open-uri'
require 'pdf-reader'

class Article < ApplicationRecord
  has_one_attached :document

  def pages
    io = ActiveStorage::Blob.service.path_for(document.key)
    reader = PDF::Reader.new(io)
    return reader.page_count

  #   # puts reader.pdf_version
  #   # puts reader.info
  #   # puts reader.metadata
  #   # puts reader.page_count
  end

  def info
    io = ActiveStorage::Blob.service.path_for(document.key)
    reader = PDF::Reader.new(io)
    i = reader.page(4).text.to_s
    client = OpenAI::Client.new
    chaptgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "Give the top 5 key facts from: #{i}"}]
    })
    return chaptgpt_response["choices"][0]["message"]["content"]
  end
end
