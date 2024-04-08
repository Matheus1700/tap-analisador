function main()
    str1 = "00:03:70,915 --> 00:03:40,619"
    str2 = "##:##:##,### --> ##:##:##,###"

    local linha = "♪ Give me more"
    local linhaSemEspeciais = removerCaracteresEspeciais(linha)
    print(linhaSemEspeciais) -- Imprime: More give me more


end

function removerCaracteresEspeciais(linha)
  local simbolosMusicais = "♪"
  local pontuacao = "!?,.;"
  local caracteresEspeciais = "["..simbolosMusicais..pontuacao.."]"

  return linha:gsub(caracteresEspeciais, "")
end

function primeiroTeste() 
  local match = true

    for i = 1, #str1 do
      if str1:sub(i, i) ~= str2:sub(i, i) and str2:sub(i, i) ~= "#" then
        match = false
        break
      end
    end
    
    if match then
      print("Verdadeiro")
    else
      print("Falso")
    end
end 

function testeTags()
    local textoComTags = "<in>Bom dia</io>"
    local textoSemTags = textoComTags:gsub("<[^>]*>", "")
    print(textoComTags)
    print(textoSemTags)
end

function detectarTagCor(linha)
  local linhaSemCor = linha:gsub("<font color>.*?</font>", "")
  
  if linhaSemCor ~= linha then
    print("Encontrada tag <font color> na linha: " .. linha)
  end
end

main()