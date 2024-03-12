class Article < ApplicationRecord
  has_one_attached :document

  def content
    client = OpenAI::Client.new
    chaptgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "What is #{title}? Return one sentence without opinions or comments. Just facts."}]
    })
    return chaptgpt_response["choices"][0]["message"]["content"]
  end

end
