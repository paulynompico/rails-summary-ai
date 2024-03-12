require 'rubygems'
require 'open-uri'
require 'pdf-reader'

class Article < ApplicationRecord
  has_one_attached :document

  def pages
    io = ActiveStorage::Blob.service.path_for(document.key)
    reader = PDF::Reader.new(io)
    return reader.page_count
  end

  def info
    io = ActiveStorage::Blob.service.path_for(document.key)
    reader = PDF::Reader.new(io)
    i = ""
    if reader.page_count >= 10 
      i += reader.page(4).text.to_s
      i += reader.page(5).text.to_s
      i += reader.page(7).text.to_s
      i += reader.page(8).text.to_s
      i += reader.page(9).text.to_s
    else
      reader.pages.each do |page|
        i += page.text.to_s
      end
    end
    client = OpenAI::Client.new
    chaptgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "Give the top 5 key facts from: #{i}. 1 sentence per fact."}]
    })
    return chaptgpt_response["choices"][0]["message"]["content"]
  end

  def summary
    io = ActiveStorage::Blob.service.path_for(document.key)
    reader = PDF::Reader.new(io)
    i = ""
    if reader.page_count >= 10 
      i += reader.page(4).text.to_s
      i += reader.page(5).text.to_s
      i += reader.page(7).text.to_s
      i += reader.page(8).text.to_s
      i += reader.page(9).text.to_s
    else
      reader.pages.each do |page|
        i += page.text.to_s
      end
    end
    client = OpenAI::Client.new
    chaptgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "Summarize #{i} as concisely as possible."}]
    })
    return chaptgpt_response["choices"][0]["message"]["content"]
  end
end
