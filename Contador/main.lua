-- Remover o BOM dos arquivos de texto [-3 caracteres talvez]
-- Remover as tags html
-- Mostrar apenas o texto

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

-- problema aqui
function removerLinhasIndesejadas(linhas)
    local novoArray = {}

    for _, linha in ipairs(linhas) do
        if not isNumeric(linha) and not verificarMinutagem(linha) then
                table.insert(novoArray, linha)
        end
    end

    return novoArray
end

function main()
    local arquivo = "../vikings-first-season/Vikings.S01E01.1080p.WEB-DL.AC3.X264-MRSK.srt"

    local conteudo = removerLinhasIndesejadas(removerEspacos(lerArquivo(arquivo)))

    
    if conteudo then
        print("------------------------------")
        for i = 1, 20 do
            print(conteudo[i])
        end
    else
        print("Erro ao ler o arquivo.")
    end
end

main()
