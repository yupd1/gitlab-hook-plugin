require 'net/http'

def incoming_payload(filename, tempdir)
  uri = URI "http://localhost:8080/gitlab/build_now"
  req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
  req.body = File.read("spec/fixtures/payloads/#{filename}.json") % { repodir: tempdir }
  http = Net::HTTP.new uri.host, uri.port
  response = Net::HTTP.start(uri.hostname, uri.port).request req
end

def wait_for(url, xmlpath, waittime=60)
  count = waittime / 5
  begin
    visit url
    break if page.has_xpath? xmlpath
    sleep 5
  end until (count-=1).zero?
end

