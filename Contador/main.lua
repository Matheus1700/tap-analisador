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

function removerLinhasIndesejadas(linhas)
    local novoArray = {}

    for _, linha in ipairs(linhas) do
        if not isNumeric(linha) and not linha:match("^%d%d:%d%d:%d%d,%d%d%d --> %d%d:%d%d:%d%d,%d%d%d$") then -- se nao for numerico 
            table.insert(novoArray, linha)
        end
    end

    return novoArray
end

function main()
    local arquivo = "../vikings-first-season/Vikings.S01E01.1080p.WEB-DL.AC3.X264-MRSK.srt"
    -- aqui nesse moente cabe eu encadear funcoes
    local conteudo = lerArquivo(arquivo)
    local novoConteudo = removerEspacos(conteudo)
    local novoNovoConteudo = removerLinhasIndesejadas(novoConteudo)

    if novoNovoConteudo then
        for i = 1, 40 do -- Comece de 1 ao invés de 0 para Lua
            print(novoNovoConteudo[i])
        end
    else
        print("Erro ao ler o arquivo.")
    end
end

main()
