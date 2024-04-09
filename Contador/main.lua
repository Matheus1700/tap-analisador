local M = require("funcoes")

function lerArquivo(arquivo)
    local linhas = {}
    local file = io.open(arquivo, "r")
    if file then
        for linha in file:lines() do
            table.insert(linhas, linha)
        end
        file:close()
    else
        print("Erro ao abrir o arquivo: " .. arquivo)
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
    local modelo = "##:##:##,### --> ##:##:##,###"

    for i = 1, #valor do
        if valor:sub(i, i) ~= modelo:sub(i, i) and modelo:sub(i, i) ~= "#" then
            match = false
            break
        end
    end

    return match
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
            local linhaSemTags = linha:gsub(modeloSemTags, "")
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
    caracteresEspeciais = caracteresEspeciais .. '"'

    local novoArray = {}
    for c in linha:gmatch(".") do
        if not caracteresEspeciais:find(c, 1, true) then
            table.insert(novoArray, c)
        end
    end

    return table.concat(novoArray)
end

function contarPalavras(conteudoLimpo)
    local contagemPalavras = {}
    conteudoLimpo = M.map(string.lower, conteudoLimpo)

    for _, linha in ipairs(conteudoLimpo) do
        if linha then 
            for palavra in linha:gmatch("%S+") do
                contagemPalavras[palavra] = (contagemPalavras[palavra] or 0) + 1
            end
        end
    end

    return contagemPalavras
end

function criarJSON(listaPalavras, episodioEscolhido)
    local json = require "json"
    local arquivoJSON = "contagem_palavras_episodio_" .. episodioEscolhido .. ".json"
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
        print("Contagens das palavras do episodio " .. episodioEscolhido .. " foram escritas em '" .. arquivoJSON .. "'.")
    else
        print("Erro ao abrir o arquivo JSON para escrita.")
    end
end

function main()
    for episodioEscolhido = 1, 9 do
        local arquivo = string.format("../vikings-first-season/Vikings.S01E0%d.1080p.WEB-DL.AC3.X264-MRSK.srt", episodioEscolhido)
        local conteudoOriginal = lerArquivo(arquivo)
        local conteudoLimpo = removerLinhasIndesejadas(removerEspacos(conteudoOriginal))
        conteudoLimpo = removerTags(conteudoLimpo)
        
        local contagemPalavras = contarPalavras(conteudoLimpo)
        
        local listaPalavras = {}
        for palavra, frequencia in pairs(contagemPalavras) do
            table.insert(listaPalavras, {palavra = palavra, frequencia = frequencia})
        end

        local function compararFrequencia(a, b)
            return a.frequencia > b.frequencia 
        end
        table.sort(listaPalavras, compararFrequencia)

        criarJSON(listaPalavras, episodioEscolhido)
    end
end

main()