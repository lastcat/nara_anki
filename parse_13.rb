require 'open-uri'
require 'pdf-reader'
require 'pry'

#[*10..15].each do |i|
    i = 13
    puts i.to_s + '回'
    text_url = 'https://www.nara-cci.or.jp/narakentei/06/'  +  i.to_s + '/02.pdf'
    answer_url = 'https://www.nara-cci.or.jp/narakentei/06/' + i.to_s + '/02_ans.pdf'

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
            text_and_options = page.text.gsub(/ |　/, '').split("\n\n\n\n\n")
            text_and_options[0] = text_and_options[0].split("\n\n\n")[1]
            text_and_options.each do |e|
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
                    next
                end
                #最初の"1)"みたいなのを除く
                _e = e.split(')')[1..-1].join(')')
                #問題と回答を分ける
                begin 
                    t_a = _e.split(/\n{2,}ア/)
                rescue =>  error
                    puts '個別対応B'
                    puts e
                    next
                end
                question = t_a[0]
                answers = t_a[1]
                #　ア.イ.ウ.エを除く
                begin
                    answers = t_a[1].gsub(/\n/, '').split('．')
                    answers_array = [answers[1][0..-2], answers[2][0..-2], answers[3][0..-2], answers[4]]
                rescue =>  error
                    binding.irb
                    puts '個別対応C'
                    puts e
                    next
                end
                questions.push([number, question, answers_array])
            end
        end
    end
    # binding.irb
    questions.each do |q|
        #puts '問題: ' + q[0].to_s
        #puts q[1]
        #puts '解答: ' + q[2][a_answers[q[0]]]
        if q[0] >= 1 && q[0] <= 9
            File.open('shizen.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t気候、地理、動植物")
            end
        end
        if q[0] >= 10 && q[0] <= 18
            File.open('rekisi.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t歴史")
            end
        end
        if q[0] >= 19 && q[0] <= 27
            File.open('iseki.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t遺跡、古墳")
            end
        end
        if q[0] >= 28 && q[0] <= 45
            File.open('shrine.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t寺社")
            end
        end
        if q[0] >= 46 && q[0] <= 54
            File.open('build.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t建築、彫刻、絵画")
            end
        end
        if q[0] >= 55 && q[0] <= 63
            File.open('bungaku.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t文学")
            end
        end
        if q[0] >= 64 && q[0] <= 72
            File.open('kougei.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t工芸、特産品")
            end
        end
        if q[0] >= 73 && q[0] <= 81
            File.open('maturi.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t祭り、伝統行事")
            end
        end
        if q[0] >= 82 && q[0] <= 90
            File.open('kankou.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t観光")
            end
        end
        if q[0] >= 91
            File.open('tokushu.txt', 'a') do |f|
                f.puts("#{q[1]}\t#{q[2][a_answers[q[0]]]}\t特集")
            end
        end
    end

#end