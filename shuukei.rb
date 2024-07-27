require 'open-uri'
require 'pdf-reader'
require 'pry'

files = [
    'build.txt',
    'bungaku.txt',
    'iseki.txt',
    'kankou.txt',
    'kougei.txt',
    'maturi.txt',
    'rekisi.txt',
    'shizen.txt',
    'tokushu.txt'
]

answers = {}
problems = {}

#=begin
files.each do |i|
    File.open(i, mode="rt") do |f|
        lines = f.readlines
        lines.each_with_index do |l, idx|
            if (idx == 0 || idx == 1 || idx == 2 || idx == 3)
                next
            end
            answer = l.split("\t")[1]
            problems[l.split("\t")[0]] = {
                'count' => 0,
                'related_words' => [answer],
                'marked' => false,
                'answer' => answer
            }
            if (answer == nil) then
                puts l
            end
            if (answers.keys.include?(answer)) then
                answers[answer] += 1
            else
                answers[answer] = 1
            end
        end
    end
end

# answers: key回答、value登場回数のハッシュ
# problems: key問題文、value:色々入れた連想配列



# ある回答が他の問題文に出ている場合、問題の登場数に+1して関連ワードに追加する
answers.keys.each do |a|
    problems.keys.each do |pro|
        if(problems[pro]['answer'] == a || (a.length > 1 && pro.include?(a)) || (a.length > 1 && problems[pro]['answer'].include?(a))) then
            problems[pro]['count'] += 1
            problems[pro]['related_words'] = problems[pro]['related_words'] | [a]
        end
    end
end
=begin
problems.sort_by {|key, val| -val['count'] }.each do |a|
    p a
    puts "\n"
end
=end
related_problems = []

#=begin
problems.keys.each do |k|
    related_set = []
    unless problems[k]['marked'] then
        #k: 問題文
        #+problems[k]['answer']: 答え
        puts k+" A:" +problems[k]['answer']
        puts "の類題"
        related_set.push(k+" A: " +problems[k]['answer'])
        problems[k]['marked'] = true
        problems.keys.each do |_k|
            #なんか空文字列が引っかかるから1以上にしてみる
            if  problems[_k]['marked'] == false && (problems[k]['related_words'] & problems[_k]['related_words']).filter{|a| a.length > 2}.length > 0
                set = []
                set.push(_k+" A: " +problems[_k]['answer'])
                set.push("共通ワード: " + (problems[k]['related_words'] & problems[_k]['related_words'])[0])
                related_set.push(set)
                problems[_k]['marked'] = true
                problems[k]['related_words'] = problems[k]['related_words'] | problems[_k]['related_words']
                puts "    " + _k+" A:" +problems[_k]['answer']
                puts "        共通ワード: " + (problems[k]['related_words'] & problems[_k]['related_words']).to_s
                #p problems[k]['related_words'] & problems[_k]['related_words']
            end
        end
    end
    #puts "\n"
    #p related_set
    if (related_set.length > 0) then
        related_problems.push(related_set)
    end
end

#=begin
related_problems.sort_by{|a| a.length}.reverse.each do |set|
    set.each do |e|
        p e
    end
    puts "重要度: " + set.length.to_s
    puts "\n"
end
#=end
=begin
array = [1,2,3,4]
array.each_with_index do |e,i|
    array.each do |e|
        p array
        array[i] = 100
    end
end
=end