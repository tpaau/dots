# Time in seconds between media fetches.
#
# Decreasing this value increases the frequency of media fetching, while
# increasing it reduces CPU usage.
#
# For example, setting this to 0.033 should theoretically result in 30 updates
# per second, though this calculation skips the actual time required to fetch
# media.
FETCH_DELTA=0.05

# The maximum length of the output string.
#
# Setting this to 0 disables the output length limit.
MAX_OUTPUT_LENGTH=45

# The order in which the cover is to be extracted
COVER_SOURCE_ORDER=("cmus" "mpris:artUrl")
