namespace :hotfix1 do

  desc "Remove orphaned selections"
  task :remove_orphaned_selections => :environment do
    puts "Songs before: #{Song.count}"
    puts "Users before: #{User.count}"
    Selection.all.each do |selection|
      if User.where(id: selection.user_id).empty?
        p selection
        selection.destroy
      end
    end
    puts "Songs after: #{Song.count}"
    puts "Users after: #{User.count}"
  end
end
