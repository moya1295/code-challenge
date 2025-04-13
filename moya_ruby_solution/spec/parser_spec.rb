require_relative '../lib/parser'

describe GoogleArtworksParser do
  let(:html) { File.read("sample_html_files/van-gogh-paintings.html", encoding: "utf-8") }
  let(:parser) { GoogleArtworksParser.new(html) }
end