require 'transmission'

module Agents
  class TransmissionAgent < Agent
    include FormConfigurable
    can_dry_run!
    no_bulk_receive!
    default_schedule '12h'

    description do
      <<-MD
      The huginn transmission agent manages downloads.

      `debug` is used to verbose mode.

      `transmission_server` is the transmission server's ip / name.

      `url` is the url of the torrent file.

      `username` for credentials.

      `password` for credentials.

      `emit_event` for creating event.
      MD
    end

    event_description <<-MD
      Events look like this:

          {
            "activityDate": 0,
            "addedDate": 1629659622,
            "bandwidthPriority": 0,
            "comment": "\"Debian CD from cdimage.debian.org\"",
            "corruptEver": 0,
            "creator": "",
            "dateCreated": 1628941778,
            "desiredAvailable": 0,
            "doneDate": 0,
            "downloadDir": "/home/transmission/.config/transmission-daemon",
            "downloadLimit": 100,
            "downloadLimited": false,
            "downloadedEver": 0,
            "error": 0,
            "errorString": "",
            "eta": -1,
            "etaIdle": -1,
            "fileStats": [
              {
                "bytesCompleted": 0,
                "priority": 0,
                "wanted": true
              }
            ],
            "files": [
              {
                "bytesCompleted": 0,
                "length": 459276288,
                "name": "debian-edu-11.0.0-amd64-netinst.iso"
              }
            ],
            "hashString": "899d629411da83faf1893f77266d8b40b3adecde",
            "haveUnchecked": 0,
            "haveValid": 0,
            "honorsSessionLimits": true,
            "id": 2,
            "isFinished": false,
            "isPrivate": false,
            "isStalled": false,
            "leftUntilDone": 459276288,
            "magnetLink": "magnet:?xt=urn:btih:899d629411da83faf1893f77266d8b40b3adecde&dn=debian-edu-11.0.0-amd64-netinst.iso&tr=http%3A%2F%2Fbttracker.debian.org%3A6969%2Fannounce",
            "manualAnnounceTime": -1,
            "maxConnectedPeers": 50,
            "metadataPercentComplete": 1,
            "name": "debian-edu-11.0.0-amd64-netinst.iso",
            "peer-limit": 50,
            "peers": [],
            "peersConnected": 0,
            "peersFrom": {
              "fromCache": 0,
              "fromDht": 0,
              "fromIncoming": 0,
              "fromLpd": 0,
              "fromLtep": 0,
              "fromPex": 0,
              "fromTracker": 0
            },
            "peersGettingFromUs": 0,
            "peersSendingToUs": 0,
            "percentDone": 0,
            "pieceCount": 1752,
            "pieceSize": 262144,
            "pieces": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
            "priorities": [
              0
            ],
            "queuePosition": 0,
            "rateDownload": 0,
            "rateUpload": 0,
            "recheckProgress": 0.0005,
            "secondsDownloading": 0,
            "secondsSeeding": 0,
            "seedIdleLimit": 30,
            "seedIdleMode": 0,
            "seedRatioLimit": 2,
            "seedRatioMode": 0,
            "sizeWhenDone": 459276288,
            "startDate": 0,
            "status": "checking",
            "torrentFile": "/home/transmission/.config/transmission-daemon/torrents/debian-edu-11.0.0-amd64-netinst.iso.899d629411da83fa.torrent",
            "totalSize": 459276288,
            "trackerStats": [
              {
                "announce": "http://bttracker.debian.org:6969/announce",
                "announceState": 0,
                "downloadCount": -1,
                "hasAnnounced": false,
                "hasScraped": false,
                "host": "http://bttracker.debian.org:6969",
                "id": 0,
                "isBackup": false,
                "lastAnnouncePeerCount": 0,
                "lastAnnounceResult": "",
                "lastAnnounceStartTime": 0,
                "lastAnnounceSucceeded": false,
                "lastAnnounceTime": 0,
                "lastAnnounceTimedOut": false,
                "lastScrapeResult": "",
                "lastScrapeStartTime": 0,
                "lastScrapeSucceeded": false,
                "lastScrapeTime": 0,
                "lastScrapeTimedOut": 0,
                "leecherCount": -1,
                "nextAnnounceTime": 0,
                "nextScrapeTime": 1629659790,
                "scrape": "http://bttracker.debian.org:6969/scrape",
                "scrapeState": 1,
                "seederCount": -1,
                "tier": 0
              }
            ],
            "trackers": [
              {
                "announce": "http://bttracker.debian.org:6969/announce",
                "id": 0,
                "scrape": "http://bttracker.debian.org:6969/scrape",
                "tier": 0
              }
            ],
            "uploadLimit": 100,
            "uploadLimited": false,
            "uploadRatio": -1,
            "uploadedEver": 0,
            "wanted": [
              1
            ],
            "webseeds": [
        
            ],
            "webseedsSendingToUs": 0
          }
    MD

    def default_options
      {
        'transmission_server' => '',
        'url' => '',
        'port' => '9091',
        'username' => '',
        'password' => '',
        'debug' => 'false',
        'emit_event' => 'true'
      }
    end

    form_configurable :transmission_server, type: :string
    form_configurable :url, type: :string
    form_configurable :port, type: :string
    form_configurable :username, type: :string
    form_configurable :password, type: :string
    form_configurable :emit_event, type: :boolean
    form_configurable :debug, type: :boolean
    def validate_options
      if options.has_key?('emit_event') && boolify(options['emit_event']).nil?
        errors.add(:base, "if provided, emit_event must be true or false")
      end

      unless options['transmission_server'].present?
        errors.add(:transmission_server, "transmission_server is a required field")
      end

      unless options['port'].present?
        errors.add(:port, "port is a required field")
      end

      unless options['url'].present?
        errors.add(:url, "url is a required field")
      end

      unless options['password'].present?
        errors.add(:password, "password is a required field")
      end

      unless options['username'].present?
        errors.add(:username, "username is a required field")
      end

      if options.has_key?('debug') && boolify(options['debug']).nil?
        errors.add(:base, "if provided, debug must be true or false")
      end
    end

    def working?
      !recent_error_logs?
    end

    def receive(incoming_events)
      incoming_events.each do |event|
        interpolate_with(event) do
          fetch
        end
      end
    end

    def check
      handle
    end

    private

    def handle
      t = Transmission.new({
        :host => interpolated['transmission_server'],
        :port => 9091,
        :user => interpolated['username'],
        :pass => interpolated['password']
      })
      
      case interpolated['url']
      when /^http.*$/
        output = t.add_torrentfile(interpolated['url'])
      when /^magnet.*$/
        output = t.add_magnet(interpolated['url'])
      end
      if interpolated['debug'] == 'true'
        log output.class
        if output.nil?
          log "nothing happened"
        else
          log t.get(output['id'])
        end
      end
      if interpolated['emit_event'] == 'true'
        if output.nil?
          create_event :payload => { 'status' => "nothing happened" }
        else
          create_event :payload => t.get(output['id'])
        end
      end
    end
  end
end
