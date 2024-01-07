# 40k-horde-mode-latex

Tooling to generate printable game rsources for Poorhammer 40k Horde mode from markdown files. tl;dr; check the `print-me` directory.

### What is Horde mode?

40k Horde Mode is a fan-made expansion to Games Workshop's Warhammer 40 000 tabletop wargame which allows single- or co-operative games against simulated opponents who follow a very sophisticated decision making algorithm. The Horde Mode is designed by the geniuses behind [The Poorhammer Podcast](https://www.youtube.com/@thepoorhammerpodcast) and it was introduced in their episode ["Horde Mode - Playing COD Zombies in 40K"](https://www.youtube.com/watch?v=PEpFsD6oyMY). The original game resources can be found from [their Google Drive folder](https://drive.google.com/drive/folders/1RCDEfbaJafpfVCU-8iDjCZe_uoPjZLYz), which hosts the latest release from the designers.

### What is this repository then? The Google Drive has the rules and the cards already?

I wanted my version of the Horde Mode to have a few modifications to the original posted by the Poorhammer team. The main motivations for this edition are as follow:

* All the game material comes in the 120 x 70mm sized "Tarot" -size. 
  * This is the same geometry as used in the official Games Workshop Warhammer 10th edition mission card deck. When I print my own copy of the Horde Mode, I can cram all the cards, all the spawn tables, the rule book and other material to a box which fits neatly right next to  the Leviathan Mission deck (and likely future mission packs to the game) in my game boxes.
  * Having a larger card size also makes it easier for the automation to generate readable playing material as we have more space to fit text into.

* The material is all monochrome and with minimal visual additions
  * I have a B&W printer.
  * The game is in playtesting stage. As the rules change every few months, it hurts very little to make updated copies when changes are required.
  * The templates provided are easier to understand and modify should we wisth to make a more visually interesting versions or do other kinds of modification. It's easier to do modifications by adding stuff rather than requiring removal of elements first.

* The material comes printer-friendly with crop-markings and all the magical things supported by LaTeX
  * These card and booklet designs have decent amount of white margins along with optional crop markings to help your paper cut process. They do look like homebrew, but like good homebrew.

* The printable material is computer generated requiring no manual typesetting or design involvement when changes are introduced
  * In my opinion, the visual design of the game material should be separated from the rule/content development. At least when the game is in playtesting stage. Being able to automatically generate a new set of printable cards, books and leaflets when rule changes are introduced should make the playtesting easier for everyone involved. 
    * Want to change Stray Orbital Bombardment to yield 3D6 mortal wounds instead of 2? Just make a change to the source markdown file, run the card generation script, print the newer version and have your modified version on the table in 10 minutes.

### Sounds cool, but I don't want to install gigabytes of dependencies and learn how to compile documents to get this version.

The quick-start way to get this edition to your printer would be to navigate to the `print-me` directory of this repository and download the files included there. From that directory, you probably want to print at least the following:

* Either `core-rules-onscreen-version-with-no-print-aids.pdf` or `core-rules-two-sided-booklet-broadside-print.pdf`
  * This contains the core ruleset of Horde Mode. The "onscreen" -version is just the rules printed to a paginated .pdf without any cut-aids sized to 120x70mm size. If you have access to printer able to make printing two-sided booklets easy, you probably want to use this. The other version "core-rules-two-sided-booklet-broadside-print" contains a version where the pages are laid out in a way that one can staple the pages on top of each other to create a "booklet" of the rules. Every second page is mirrored assuming the pages are flipped along the broadside of the paper.
* "reinforcement-points-purchase-table-printable-pdf"
  * This contains a copy of the reinforcement shop of the game. It's intended to be folded three times to an "accordion" shape after cutting along the crop marks.
* The misery, secondary and secret objective cards from `misery-card-collection.pdf`, `secondary-card-collection.pdf` and `secret-card-collection.pdf`. Printing a set and cutting along the crop marks will give you roughly 120x70mm size sheets.
* You can also print the necessary spawn tables from the `spawn-tables` directory depending on what Hordes the players intend to use. These are intended to be cut and folded similarly to the reinforcement points purchase table above.
* **Optionally** one can also print a set of backgrounds for the cards for easier identification of individual decks. Each `misery-cardback.pdf`, `secondary-cardback.pdf` and `secret-cardback.pdf` contains a page with four copies of the cardbacks along with cutmarks.
 * One can print these directly on the back of the cards one printed earlier should they be using a thick enough paper and having access to a printer being able to print very precisely to the sheets. 
 * Or they can do like me and use them to construct their own "card sandwiches" - where you slip the background paper, a thin piece of cardboard (or tarot-sized playing card from another game) and the effect card into a plastic card protector easily available from your local game store.

### I want to make modifications to the contents and render my own versions!

Cool! The card contents are maintained in a separate repository called [40k-horde-mode-markdown](https://github.com/eeko/40k-horde-mode-markdown). Copy of it is included as a subrepository of this one, so you only need to git clone this one to start making modifications. Once you have made the modifications needed, you can build all the necessary files by running the `run-all.sh` in the `/tools` directory. Though at this point, you probably need to be familiar on how to handle LaTeX installations and Ruby dependencies to get things working. At some point I intend to add a dockerfile which will take care of the deployment of the build-environment, but today is not the day.

