require 'open-uri'
require 'pdf-reader'
require 'pry'

text_url = 'https://www.nara-cci.or.jp/narakentei/06/16/02.pdf'

answer_url = 'https://www.nara-cci.or.jp/narakentei/06/16/02_ans.pdf'

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

        text = page.text.gsub(/{.*}/, '').gsub(/^\n/, '').gsub(/\t/, '').gsub(/ |　/, '').gsub(/^[。]\n /, '').gsub(/(?<=[^\。])\R/, '')
        text_and_options = text.split('（')
        text_and_options.each do |e|
            # ページ最初の文言を除く
            if !e.include?('ア')
                next
            end
            #ページ末尾のページ番号を除く
            e = e.split('-')[0]
            begin 
                re = Regexp.new('[0-9]+）')
                number = re.match(e)
                number = number[0][0..-2].to_i
            rescue =>  error
                puts '個別対応'
                puts e
                next
             end
            #最初の"1)"みたいなのを除く
            _e = e.split('）')[1]
            #問題と回答を分ける
            begin 
                t_a = _e.split("\n")
            rescue =>  error
               puts '個別対応'
               puts e
               next
            end
            question = t_a[0]
            answers = t_a[1]
            #　ア.イ.ウ.エを除く
            answers = t_a[1].split('．')
            answers_array = [answers[1][0..-2], answers[2][0..-2], answers[3][0..-2], answers[4]]

            questions.push([number, question, answers_array])
        end
    end
end

questions.each do |q|
    puts '問題: ' + q[0].to_s
    puts q[1]
    puts '解答: ' + q[2][a_answers[q[0]]]
end
