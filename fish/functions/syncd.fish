function sync
  rsync -urltvC \
        --delete \
        --filter ":e- .gitignore" \
        --filter "- .git/" \
        $SYNCD_SRC $SYNCD_DST
end

function syncd
  sync; fswatch -o $SYNCD_SRC | while read f; sync; end
end
