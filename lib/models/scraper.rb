# Columns to add to students table:
#  Name
#  Profile Pic
#  Social media links/ Twitter, LinkedIn, GitHub, Blog(RSS)
#  Quote
#  About/ Bio, Education, Work
#  Coder Cred / Treehouse, Codeschool, Coderwal .reject(Github)

require 'nokogiri'
require 'open-uri'
require 'sqlite3'

require 'pp'
require 'json'

class Scraper

  attr_accessor :db, :db_name, :students_html_array, :students

  def create_database(db_name)
    @db_name = db_name
    # Create a new database and drop the students table from the database if it exists
    begin
      db = SQLite3::Database.new db_name
      db.execute("DROP TABLE IF EXISTS students")
    rescue SQLite3::Exception => e 
      puts "Exception occurred"
      puts e
    ensure
      db.close if db
    end 
  end


  def scrape_index(index_html)
    
    # scrape different HTML elements
    index = Nokogiri::HTML(open(index_html))

    student_a_selector = "li.home-blog-post div.blog-title h3 a" # div.big-comment before "a" won't select Matt's profile
    names = index.css(student_a_selector).collect{|student| student.content}
    urls  = index.css(student_a_selector).collect{|student| student.attr("href").downcase}
    @students_html_array = urls.reject{|url| url == "#"}
    urls  = urls.collect{ |url| url.sub("students/","") }

    student_img_selector = "li.home-blog-post div.blog-thumb img"
    imgs = index.css(student_img_selector).collect{|student| student.attr("src").downcase}
    imgs = imgs.collect{ |img| (img[0..3]=="http" ? "" : "/") + img }

    student_tagline_selector = "li.home-blog-post p.home-blog-post-meta"
    taglines = index.css(student_tagline_selector).collect{|student| student.content}

    student_bio_selector = "li.home-blog-post div.excerpt p"
    bios = index.css(student_bio_selector).collect{|student| student.content}

    # ensure sizes are all same
    raise if urls.size != names.size || urls.size != imgs.size || urls.size != taglines.size || urls.size != bios.size

    # create array of all data
    students_array = []
    names.each_with_index do |student, index|
      students_array << {:name=>names[index], :url=>urls[index], :img=>imgs[index], :tagline=>taglines[index], :bio=>bios[index]}
    end

    #convert into hash and store as instance variable
    students_array.delete_if { |info| info[:url]=="#" }
    @students ||= {}
    students_array.each_with_index {|info, index| @students[index+1] = info}
    # {1 => {:name=> "Avi Flombaum", :img=> "http://avi.com"}, 2 => {:name=> "Ashley Williams", :img=> "http://ashley.com"}}
    
    # pp @students
    puts "\nThe students_html_array looks like this:\n #{students_html_array.inspect}"
    puts "There are #{students_html_array.size} elements in the array"

  end


  # Scrape individual student profiles based on the array created from scraping index.html

  def scrape_students(index_html)
    # Loop through each student profile URL in @students
    @students_html_array.each_with_index do |student_html, index|
      begin
        puts
        student_page = Nokogiri::HTML(open("#{index_html}/#{student_html}"))

        # Get student's name
        name_css_selector = "h4.ib_main_header"
        html_tag_for_name = student_page.css(name_css_selector).first # will return nil if the ib_main_header css selector is not found
        # puts html_tag_for_name.class => Nokogiri::XML::Element

        # only scrape the rest of page if html_tag_for_name is found (to make sure that only correctly formatted pages are scraped)
        if html_tag_for_name
          puts "...scraping: #{student_html}"

          info = {}
          info[:name] = html_tag_for_name.content

          prof_pic_selector = "div .student_pic"
          info[:prof_pic] = student_page.css(prof_pic_selector).attr("src").to_s

          social_media_selector = "div.social-icons a"
          info[:twitter]  = student_page.css(social_media_selector)[0].attr("href")
          info[:linkedin] = student_page.css(social_media_selector)[1].attr("href")
          info[:github]   = student_page.css(social_media_selector)[2].attr("href")
          info[:blog]     = student_page.css(social_media_selector)[3].attr("href")

          quote_selector = "div.textwidget"
          info[:quote]    = student_page.css(quote_selector).text

          student = {(index+1) => info}
          p student

          # merge into existing hash
          @students.merge!(student) do |id, oldinfo, newinfo|
            oldinfo.merge!(newinfo) do |attribute, oldvalue, newvalue|
              puts "in index: #{oldvalue}; in profile: #{newvalue}" if oldvalue != newvalue
              newvalue
            end
          end

        else
          puts "#{student_html} isn't the correct template.  Page will not be scraped."
        end

      rescue OpenURI::HTTPError => e
        puts "No profile found at " + student_html
        puts e
      end
    end
  end


  def insert_into_db(db_name)
    @students.each do |id, student|
      columns_names        = student.keys.join(",").gsub(",", " TEXT, ") + " TEXT"
      student_attributes   = student.keys.join(",")
      student_values       = student.keys.to_s.gsub("]", "").gsub("[", "")

      db = SQLite3::Database.open db_name
      db.execute("CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY AUTOINCREMENT, 
                                                      #{columns_names})"
                )

      # insert specific student into students table if it doesn't exist
      db.execute("DELETE FROM students WHERE name=?", student[:name])
      db.execute("INSERT INTO students(#{student_attributes}) 
                              VALUES (#{student_values})", student
                )
    end
    puts "\nSuccessfully updated database!"
  end

end


db_name = "flatiron.db"
index_html = "http://students.flatironschool.com"

scraper = Scraper.new
scraper.create_database(db_name)

scraper.scrape_index(index_html)
scraper.scrape_students(index_html)
# pp scraper.students

scraper.insert_into_db(db_name)

