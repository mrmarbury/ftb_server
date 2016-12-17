name "ftb"
description "Feed the Beast Server"
run_list "recipe[role_ftb_server]"
override_attributes({
  "ftb_server" => {
      "pack" => {
          "name" => "FTBInfinityLite110",
          "version" => "1.3.3"
      }
  }
})
