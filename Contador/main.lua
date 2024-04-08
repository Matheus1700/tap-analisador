-- Fazer um JSON
-- Contar cada palavra no JSON

function lerArquivo(arquivo)
    local linhas = {}
    for linha in io.lines(arquivo) do
        table.insert(linhas, linha)
    end

    return linhas
end

function removerEspacos(linhas)
    local novoArray = {}
    for chave, valor in ipairs(linhas) do
        if valor ~= "" then
            table.insert(novoArray, linhas[chave])
        end
    end

    return novoArray
end

function isNumeric(valor)
    valor = valor:gsub("^\xEF\xBB\xBF", "")
    return tonumber(valor) ~= nil
end

function verificarMinutagem(valor)
    local match = true
    modelo = "##:##:##,### --> ##:##:##,###"

    for i = 1, #valor do
      if valor:sub(i, i) ~= modelo:sub(i, i) and modelo:sub(i, i) ~= "#" then
        match = false
        break
      end
    end
    
    if match then
      return true
    else
      return false
    end
end

function removerLinhasIndesejadas(linhas)
    local novoArray = {}

    for _, linha in ipairs(linhas) do
        if not isNumeric(linha) and not verificarMinutagem(linha) then
                table.insert(novoArray, linha)
        end
    end

    return novoArray
end

function removerTags(linhas)
    local novoArray = {}
    local modeloSemTags = "<[^>]*>"

    for _, linha in ipairs(linhas) do
        if not linha:find("<font ") then
            linhaSemTags = linha:gsub(modeloSemTags, "")
            linhaSemTags = removerCaracteresEspeciais(linhaSemTags)
            table.insert(novoArray, linhaSemTags)
          end
    end

    return novoArray
end

function removerCaracteresEspeciais(linha)
    local simbolosMusicais = "♪"
    local pontuacao = "!?,.;-"
    local caracteresEspeciais = "["..simbolosMusicais..pontuacao.."]"
  
    return linha:gsub(caracteresEspeciais, "")
end


function contarPalavras(conteudoLimpo)
    local contagemPalavras = {}
  
    for _, linha in ipairs(conteudoLimpo) do
        if linha then 
            for palavra in linha:gmatch("%S+") do
                palavra = palavra:lower()
                contagemPalavras[palavra] = (contagemPalavras[palavra] or 0) + 1
            end
        end
    end
  
    return contagemPalavras
end
  

function criarJSON(listaPalavras)
    json = require "json"
    local arquivoJSON = "contagem_palavras.json"
    local file = io.open(arquivoJSON, "w")
    if file then
        file:write("[\n")
        local primeiraLinha = true
        for _, palavra in ipairs(listaPalavras) do
            if not primeiraLinha then
                file:write(",\n")
            else
                primeiraLinha = false
            end
            file:write('\t{\n')
            file:write('\t\t"palavra": "' .. palavra.palavra .. '",\n')
            file:write('\t\t"frequencia": ' .. palavra.frequencia .. '\n')
            file:write('\t}')
        end
        file:write("\n]\n")
        file:close()
        print("Contagens das palavras foram escritas em '" .. arquivoJSON .. "'.")
    else
        print("Erro ao abrir o arquivo JSON para escrita.")
    end
end




function main()
    local arquivo = "../vikings-first-season/Vikings.S01E01.1080p.WEB-DL.AC3.X264-MRSK.srt"

    local conteudoOriginal = lerArquivo(arquivo)
    local conteudoLimpo = removerLinhasIndesejadas(removerEspacos(conteudoOriginal))
    conteudoLimpo = removerTags(conteudoLimpo)
    
    local contagemPalavras = contarPalavras(conteudoLimpo)
    
    local listaPalavras = {}
    for palavra, frequencia in pairs(contagemPalavras) do
        table.insert(listaPalavras, {palavra = palavra, frequencia = frequencia})
    end
    table.sort(listaPalavras, function(a, b) return a.palavra < b.palavra end)

    criarJSON(listaPalavras)

end

main()
