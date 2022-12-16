def del_zero(x, y ,s ,p, open, a)
    n = 0
    -1.step(1) do |k|
        -1.step(1) do |l|
            if x+k > 0 && y+l > 0 && x+k < s+1 && y+l < s+1 then
                if p[x+k][y+l] == true then
                    n = n + 1
                end
            end
        end
    end
    if n == 0 then
        -1.step(1) do |k|
            -1.step(1) do |l|
                if open[x+k][y+l] != true && x+k != 0 && y+l != 0 && x+k != s+1 && y+l != s+1 then
                    open[x+k][y+l] = true
                    a = a - 1
                    s, p, open, a = del_zero(x+k, y+l, s, p, open, a)
                end
            end
        end
    end
    return s, p, open, a
end

def mine(s, m)
    if s < 2 || m > s**2 - 1 || m < 1 then
        printf("フィールドの大きさsは2以上である必要があります.")
        printf("また地雷の数はs^2未満の自然数である必要があります.\n")
        return "error"
    end
    input = Array.new(2,0)
    p = Array.new(s + 2) do
        Array.new(s + 2,false)
    end
    open = Array.new(s + 2) do
        Array.new(s + 2,false)
    end
    flag = Array.new(s + 2) do
        Array.new(s + 2,false)
    end
    a = s**2 - m
    count = m
    while count != 0 do
        x = rand(1..s)
        y = rand(1..s)
        if p[x][y] == false then
            p[x][y] = true
            count = count - 1
        end
    end
    printf(s.to_s + "x" + s.to_s + "のマインスイーパを開始します.\n地雷の数は" + m.to_s + "個です.\n\n")
    printf("[ルール説明]\n")
    printf("まず初めに," + s.to_s + "x" + s.to_s + "個のマスが表示されます.\n")
    printf("そのうち," + m.to_s + "マスには地雷が埋まっています.\n")
    printf("ゲームのクリア条件は地雷が埋まっていないマスをすべて開けることです.")
    printf("まだ空いていないマスは |\e[37mx\e[0m| で示されています.\nその中から地雷がないと思われるマスを指定し,\n")
    printf("行,列の順に番号を指定するとそのマスが開けられます.地雷があると即ゲームオーバーになりますが,\n")
    printf("地雷がなければそのマスの表示は数字に変わります.\n数字の値はその周り8マスに含まれる地雷の数です.\n")
    printf("なお,地雷があると思われるマスはマークしておくとそのマスが視認しやすくなります.\n\n")
    stime = Time.now
    while a != 0 do
        1.step(s) do |i|
            if i < 10 then
                printf("|" + i.to_s + "|")
            else
                printf("|" + i.to_s.slice(-1) + "|")
            end
        end
        printf("\n")
        1.step(s) do |i|
            printf("===")
        end
        printf("\n")
        raw = ""
        s.times do |i|  
            s.times do |j|
                if open[i+1][j+1] == true then
                    n = 0
                    -1.step(1) do |k|
                        -1.step(1) do |l|
                            if p[(i+1)+k][(j+1)+l] == true then
                                n = n + 1
                            end
                        end
                    end
                    if n == 0 then
                        raw += "|\e[32m" + n.to_s + "\e[0m|"
                    elsif n == 1 then
                        raw += "|\e[33m" + n.to_s + "\e[0m|"
                    elsif n == 2 then
                        raw += "|\e[35m" + n.to_s + "\e[0m|"
                    else
                        raw += "|\e[31m" + n.to_s + "\e[0m|"
                    end
                    
                else
                    if flag[i+1][j+1] == true then
                        raw += "|\e[30;47mx\e[0m|"
                    else
                        raw += "|\e[37mx\e[0m|"
                    end
                end
            end
            raw += "...[" + (i+1).to_s + "]"
            raw += "\n"
        end
        printf(raw)
        fc = 0
        1.step(s) do |i|
            1.step(s) do |j|
                if flag[i][j] == true && open[i][j] == false then
                    fc += 1
                end
            end
        end
        printf("残り\e[32m" + a.to_s + "\e[0mマス,行,列の順で番号を入力し,Enterで確定するとそのマスを開きます.\n")
        printf("行番号・列番号の両方の末尾にmを付けるとそのマスをマーク,uを付けるとアンマークします\(" + fc.to_s + "個マーク済み\).\n")
        printf("行：")
        input[0] = gets
        printf("列：")
        input[1] = gets
        if input[0].slice("m") == "m" && input[1].slice("m") == "m" then
            flag[input[0].to_i][input[1].to_i] = true
            printf("マークしました.\n\n")
        elsif input[0].slice("u") == "u" && input[1].slice("u") == "u" then
            flag[input[0].to_i][input[1].to_i] = false
            printf("アンマークしました.\n\n")
        elsif input[0].to_i <= 0 || input[1].to_i <= 0 || input[0].to_i >= s+1 || input[1].to_i >= s+1
            printf("有効な入力ではありません.各値は1から" + s.to_s + "の間で入力してください.\n\n")
        elsif flag[input[0].to_i][input[1].to_i] == true then
            printf("該当のマスはマークされています.このマスを開ける前にアンマークしてください.\n\n")
        elsif p[input[0].to_i][input[1].to_i] == true then
            printf("残念！地雷がありました！\n\n")
            printf("GAME OVER...\n")
            return
        elsif open[input[0].to_i][input[1].to_i] == true then
            printf("そのマスはすでに空いています.\n\n")
        elsif p[input[0].to_i][input[1].to_i] == false && input[0].to_i > 0 && input[1].to_i > 0 && input[0].to_i < s+1 && input[1].to_i < s+1 then
            printf("地雷はありませんでした！\n\n")
            a = a - 1
            open[input[0].to_i][input[1].to_i] = true
            s, p, open, a = del_zero(input[0].to_i, input[1].to_i, s, p, open, a)
        else
            printf("不明なエラー\n")
            return "error"
        end
    end
    etime = Time.now
    times = etime - stime
    1.step(s) do |i|
        if i < 10 then
            printf("|" + i.to_s + "|")
        else
            printf("|" + i.to_s.slice(-1) + "|")
        end
    end
    printf("\n")
    1.step(s) do |i|
        printf("===")
    end
    printf("\n")
    raw = ""
    s.times do |i|  
        s.times do |j|
            if open[i+1][j+1] == true then
                n = 0
                -1.step(1) do |k|
                    -1.step(1) do |l|
                        if p[(i+1)+k][(j+1)+l] == true then
                            n = n + 1
                        end
                    end
                end
                if n == 0 then
                    raw += "|\e[32m" + n.to_s + "\e[0m|"
                elsif n == 1 then
                    raw += "|\e[33m" + n.to_s + "\e[0m|"
                elsif n == 2 then
                    raw += "|\e[35m" + n.to_s + "\e[0m|"
                else
                    raw += "|\e[31m" + n.to_s + "\e[0m|"
                end
                
            else
                if flag[i+1][j+1] == true then
                    raw += "|\e[30;47mx\e[0m|"
                else
                    raw += "|\e[37mx\e[0m|"
                end
            end
        end
        raw += "...[" + (i+1).to_s + "]"
        raw += "\n"
    end
    printf(raw)
    printf("すべての地雷が取り除かれました!!\n")
    printf("GAME CLEAR!\n")
    times = Array.new(2,0)
    times[0] = ((etime - stime).to_i / 60)
    times[1] = ((etime - stime) % 60 ).to_i
    printf("クリア時間:" + times[0].to_s + "分" + times[1].to_s + "秒\n")
end

printf("フィールドの大きさ s を入力してください(1以上の整数)：")
$a = gets.to_i
printf("地雷の数 m を入力してください(1以上s^2未満の整数)：")
$b = gets.to_i
mine($a,$b)