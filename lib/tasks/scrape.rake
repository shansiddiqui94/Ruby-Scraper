task scrape: :environment do
  
    require 'open-uri'
  
    # link = "https://www.pokemon.com/us/pokedex/"

    link = "https://jobs.lever.co/stackadapt"
    
    doc = Nokogiri::HTML(URI.open(link))

    # doc = Nokogiri::HTML(open(URL))
    
    postings = doc.search('div.posting')
  
    postings.each do |p|
      job_title = p.search('a.posting-title > h5').text
      location = p.search('a.posting-title > div > span')[0].text
      team = p.search('a.posting-title > div > span')[1].text
      url = p.search('a.posting-title')[0]['href']
  
      # skip persisting job if it already exists in db
      if Job.where(job_title:job_title, location:location, team:team, url:url).count <= 0
        Job.create(
          job_title:job_title,
          location:location,
          team:team,
          url:url)
  
        puts 'Added: ' + (job_title ? job_title : '')
      else
        puts 'Skipped: ' + (job_title ? job_title : '')
      end
  
    end
  end