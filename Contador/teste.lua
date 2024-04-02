function main()
    str1 = "00:03:70,915 --> 00:03:40,619"
    str2 = "##:##:##,### --> ##:##:##,###"

    
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


main()