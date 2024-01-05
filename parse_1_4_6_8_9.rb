require 'open-uri'
require 'pdf-reader'
require 'pry'
4,6,8,9
[1,4,6,8,9].each do |i|
    puts i.to_s + '回'
    text_url = 'https://www.nara-cci.or.jp/narakentei/06/'  + '0' +  i.to_s + '/02.pdf'
    answer_url = 'https://www.nara-cci.or.jp/narakentei/06/' + '0' + i.to_s + '/02_ans.pdf'

    a_answers = []
    URI.open(answer_url) do |io|
        reader = PDF::Reader.new(io)
        reader.pages.each do |page|
            page.text.chars.each do |c|
                if c == 'ア'
                    a_answers.push(0)
                end
                if c == 'イ'
                    a_answers.push(1)
                end
                if c == 'ウ'
                    a_answers.push(2)
                end
                if c == 'エ'
                    a_answers.push(3)
                end
            end
        end
    end

    #問題パース部
    #=begin
    questions = []
    answers = []
    URI.open(text_url) do |io|
        reader = PDF::Reader.new(io)
        reader.pages.each do |page|
            if page.number == 1
                next
            end
            #text = page.text.gsub(/{.*}/, '').gsub(/^\n/, '').gsub(/\t/, '').gsub(/ |　/, '').gsub(/^[。]\n /, '').gsub(/(?<=[^\。])\R/, '')
            #text_and_options = text.split('（')
            #一問ごとに区切る
            text_and_options = page.text.gsub(/ |　/, '').split(/\n{3,}/)
            text_and_options.each do |initial_e|
                e = initial_e
                # ページ最初の文言を除く
                if !e.include?('ア')
                    next
                end
                #ページ末尾のページ番号を除く
                e = e.split('-')[0]
                begin 
                    re = Regexp.new('([0-9]+)')
                    number = re.match(e)
                    number = number[0].to_i
                rescue =>  error
                    puts '個別対応A'
                    puts e
                    #binding.irb
                    next
                end
                #最初の"1)"みたいなのを除く
                _e = e.split(')')[1..-1].join(')')
                if (e.split(')')).length < 2
                    _e =  e.split('）')[1..-1].join('）')
                end
                #問題と回答を分ける
                begin 
                    t_a = _e.split(/\n{2,}ア/)
                    if (t_a.length < 2)
                        t_a = _e.split(/\n{1,}ア/)
                    end
                rescue =>  error
                    puts '個別対応B'
                    puts e
                    #binding.irb
                    next
                end
                begin
                    question = t_a[0].gsub(/\n/, '')
                    answers = t_a[1]
                    #　ア.イ.ウ.エを除く
                    answers = t_a[1].gsub(/\n/, '').split('．')
                    answers_array = [answers[1][0..-2], answers[2][0..-2], answers[3][0..-2], answers[4]]
                rescue =>  error
                    puts '個別対応C'
                    puts e
                    #binding.irb
                    next
                end
                questions.push([number, question, answers_array])
            end
        end
    end

    questions.each do |q|
        #puts '問題: ' + q[0].to_s
        #puts q[1]
        #puts '解答: ' + q[2][a_answers[q[0]]]
        if i == 1
            if q[0] >= 1 && q[0] <= 11
                File.open('shizen.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t気候、地理、動植物")
                end
            end
            if q[0] >= 12 && q[0] <= 24
                File.open('rekisi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t歴史")
                end
            end
            if q[0] >= 25 && q[0] <= 40
                File.open('iseki.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t遺跡、古墳")
                end
            end
            if q[0] >= 41 && q[0] <= 59
                File.open('shrine.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t寺社")
                end
            end
            if q[0] >= 60 && q[0] <= 68
                File.open('build.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t建築、彫刻、絵画")
                end
            end
            if q[0] >= 69 && q[0] <= 76
                File.open('bungaku.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t文学")
                end
            end
            if q[0] >= 77 && q[0] <= 84
                File.open('kougei.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t工芸、特産品")
                end
            end
            if q[0] >= 85 && q[0] <= 92
                File.open('maturi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t祭り、伝統行事")
                end
            end
            if q[0] >= 93 && q[0] <= 100
                File.open('kankou.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t観光")
                end
            end
        end
        if i == 4
            if q[0] >= 1 && q[0] <= 9
                File.open('shizen.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t気候、地理、動植物")
                end
            end
            if q[0] >= 10 && q[0] <= 25
                File.open('rekisi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t歴史")
                end
            end
            if q[0] >= 26 && q[0] <= 41
                File.open('iseki.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t遺跡、古墳")
                end
            end
            if q[0] >= 42 && q[0] <= 59
                File.open('shrine.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t寺社")
                end
            end
            if q[0] >= 60 && q[0] <= 69
                File.open('build.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t建築、彫刻、絵画")
                end
            end
            if q[0] >= 70 && q[0] <= 78
                File.open('bungaku.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t文学")
                end
            end
            if q[0] >= 79 && q[0] <= 87
                File.open('kougei.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t工芸、特産品")
                end
            end
            if q[0] >= 88 && q[0] <= 93
                File.open('maturi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t祭り、伝統行事")
                end
            end
            if q[0] >= 94 && q[0] <= 100
                File.open('kankou.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t観光")
                end
            end
        end
        if i == 6
            if q[0] >= 1 && q[0] <= 10
                File.open('shizen.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t気候、地理、動植物")
                end
            end
            if q[0] >= 11 && q[0] <= 21
                File.open('rekisi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t歴史")
                end
            end
            if q[0] >= 22 && q[0] <= 32
                File.open('iseki.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t遺跡、古墳")
                end
            end
            if q[0] >= 33 && q[0] <= 50
                File.open('shrine.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t寺社")
                end
            end
            if q[0] >= 51 && q[0] <= 60
                File.open('build.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t建築、彫刻、絵画")
                end
            end
            if q[0] >= 61 && q[0] <= 70
                File.open('bungaku.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t文学")
                end
            end
            if q[0] >= 71 && q[0] <= 80
                File.open('kougei.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t工芸、特産品")
                end
            end
            if q[0] >= 81 && q[0] <= 90
                File.open('maturi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t祭り、伝統行事")
                end
            end
            if q[0] >= 91 && q[0] <= 100
                File.open('kankou.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t観光")
                end
            end
        end
        if i == 8
            if q[0] >= 1 && q[0] <= 10
                File.open('shizen.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t気候、地理、動植物")
                end
            end
            if q[0] >= 11 && q[0] <= 20
                File.open('rekisi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t歴史")
                end
            end
            if q[0] >= 21 && q[0] <= 31
                File.open('iseki.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t遺跡、古墳")
                end
            end
            if q[0] >= 32 && q[0] <= 49
                File.open('shrine.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t寺社")
                end
            end
            if q[0] >= 50 && q[0] <= 57
                File.open('build.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t建築、彫刻、絵画")
                end
            end
            if q[0] >= 58 && q[0] <= 68
                File.open('bungaku.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t文学")
                end
            end
            if q[0] >= 69 && q[0] <= 78
                File.open('kougei.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t工芸、特産品")
                end
            end
            if q[0] >= 79 && q[0] <= 89
                File.open('maturi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t祭り、伝統行事")
                end
            end
            if q[0] >= 90 && q[0] <= 100
                File.open('kankou.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t観光")
                end
            end
        end
        if i == 9
            if q[0] >= 1 && q[0] <= 10
                File.open('shizen.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t気候、地理、動植物")
                end
            end
            if q[0] >= 11 && q[0] <= 21
                File.open('rekisi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t歴史")
                end
            end
            if q[0] >= 22 && q[0] <= 32
                File.open('iseki.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t遺跡、古墳")
                end
            end
            if q[0] >= 33 && q[0] <= 51
                File.open('shrine.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t寺社")
                end
            end
            if q[0] >= 52 && q[0] <= 60
                File.open('build.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t建築、彫刻、絵画")
                end
            end
            if q[0] >= 61 && q[0] <= 70
                File.open('bungaku.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t文学")
                end
            end
            if q[0] >= 71 && q[0] <= 80
                File.open('kougei.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t工芸、特産品")
                end
            end
            if q[0] >= 81 && q[0] <= 90
                File.open('maturi.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t祭り、伝統行事")
                end
            end
            if q[0] >= 90 && q[0] <= 100
                File.open('kankou.txt', 'a') do |f|
                    f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t観光")
                end
            end
        end
    end
end