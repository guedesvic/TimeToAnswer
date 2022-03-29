require 'net/http'

class ZipCode
  attr_reader :logradouro, :bairro, :localidade, :uf

  END_POINT = "https://viacep.com.br/ws/"
  FORMAT = "json"

  def initialize(zip_code)
    found_zip_code = find(zip_code)
    input_data(found_zip_code)
  end

  def address
    "#{@logradouro}, #{@bairro}, #{@localidade}, #{@uf}"
  end

  private

  def input_data(found_zip_code)
    @logradouro = found_zip_code['logradouro']
    @bairro = found_zip_code['bairro']
    @localidade = found_zip_code['localidade']
    @uf = found_zip_code['uf']
  end
  
  def find(zip_code)
    ActiveSupport::JSON.decode(
      Net::HTTP.get(
        URI("#{END_POINT}#{zip_code}/#{FORMAT}/")
      )
    )
  end
end