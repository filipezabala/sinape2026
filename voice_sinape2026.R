# Código da apresentação do voice
# SINAPE 2026 - Hotel Serrano Gramado
# 2026-09-13 16:00
# version 0.5.6
# https://github.com/filipezabala/sinape2026

# 0. Package presentation and basic installation
# doi.org/10.21105/joss.08420
# https://lume.ufrgs.br/bitstream/handle/10183/297883/001294365.pdf
# https://cran.r-project.org/web/packages/voice/vignettes/voicegnette_CRAN.html
# https://www.causeweb.org/voices/2022/session/3
# https://rviews.rstudio.com/2022/10/27/september-2022-top-40-new-cran-packages/
# https://www.ocenaudio.com/

# Stable version from CRAN
install.packages('voice')

# Libs
library(voice)
library(tidyverse)

# get path to audio file
wavDir <- list.files(system.file('extdata', package = 'wrassp'),
                     pattern = glob2rx('*.wav'), full.names = TRUE)
tuneR::play(wavDir[1], player = "afplay") # macOS
tuneR::play(wavDir[9], player = "afplay") # macOS
utils::browseURL(dirname(wavDir[1]))
# tuneR::play(wavDir[1], player = "play")   # Linux/SoX
# tuneR::play(wavDir[1], player = "C:/Program Files/Windows Media Player/wmplayer.exe") # Windows


# 1. extract_features
# minimal usage
M <- voice::extract_features(wavDir)
glimpse(M)
?extract_features


# 2. tag
# creating Extended synthetic data
E <- dplyr::tibble(subject_id = c(1,1,1,2,2,2,3,3,3), 
                   wav_path = wavDir)
E

# minimal usage
voice::tag(E)

# canonical data
voice::tag(E, groupBy = 'subject_id')


# 3. Visualization
# 3.1 Get audio
url0 <- 'https://github.com/filipezabala/voiceAudios/raw/refs/heads/main/wav/doremi.wav'
file_wav0 <- paste0(tempdir(), '/doremi.wav')
download.file(url0, file_wav0, mode = 'wb')
tuneR::play(file_wav0, player = "afplay")
utils::browseURL(dirname(file_wav0))

# 3.2 Media data
M <- voice::extract_features(file_wav, features = c('f0','fmt','gain'))
summary(M)

# 3.3 Plot
voice::piano_plot(M, 0) # f0
voice::piano_plot(M, 1) # f1

# 3.4 Assign notes
(f0_spn <- voice::assign_notes(M, fmt = 0, min_points = 22, min_percentile = .85)) # f0
(f1_spn <- voice::assign_notes(M, fmt = 1, min_points = 22, min_percentile = .85)) # f1


# Instalação avançada
# https://github.com/filipezabala/voice#4-advanced-installation

# 3.5 Sheet music (Must have MuseScore and gm)
# 3.5.1 Notes sequence of f0
library(gm)
line_0 <- gm::Line(as.character(f0_spn))
m0 <- gm::Music() +
  gm::Meter(4, 4) +
  line_0
gm::show(m0, to = c('score', 'audio'))

# 3.5.2 Notes sequences of f0 and f1
line_0 <- gm::Line(as.character(f0_spn))
line_1 <- gm::Line(as.character(f1_spn))
m1 <- gm::Music() +
  gm::Meter(4, 4) +
  line_0 + line_1
gm::show(m1, to = c('score', 'audio'))


# 5. Diarize
# download
url1 <- 'https://github.com/filipezabala/voiceAudios/raw/main/wav/sherlock0.wav'
wavDir <- normalizePath(tempdir())
file_wav1 <- paste0(wavDir, '/sherlock0.wav')
download.file(url1, file_wav1, mode = 'wb')
tuneR::play(file_wav1, player = "afplay")
utils::browseURL(dirname(file_wav1))
system(paste("open -a /Applications/ocenaudio.app", shQuote(file_wav1)))

# TODO: check diarize()
# diarize
?voice::diarize
voice::diarize(fromWav = wavDir, toRttm = wavDir, pycall = '/opt/miniconda3/envs/pyvoice', token = 'MY_SECRET_TOKEN')
