This is a Terris log parser for scraping combat damage dealt by the player. For
the time being it only tracks damage done with weapons. It does not count damage
from direct damage spells, or damage from built-in weapon enchants, enchants
cast on a weapon, poisoning, etc. This thing is *very fragile* and still has
bugs, I'm sure. That's not to say you should worry about breaking it, just be aware
that it could easily throw an error while you're trying to use it.

In order for it to do a full scrape, you cannot be concentrating as it uses the
text string prior to the damage information (e.g. "Thimble aims his Smoldering
Two-Handed Sword at the Hob Goblin and hits for fatal damage") to gather
information about the type of the attack (attack, aim, or charge) the weapon
used, and the monster attacked. The log parser will automatically clean out: 

* Color Codes 
* Time-stamps 
* Weapon Enchants

So you can leave all that stuff in your logs and it shouldn't matter.

Log files are limited to 300 MB. If you find yourself with more than 300 MB
frequently, let me know and I'll see about upping the limit.

Once the log is parsed, you can download the raw parse which contains the gross,
absorbed, and net damage for each attack, the target, the weapon used, the type
of attack (a/aim/charge), whether or not it was a critical, and whether or not
it was a fatal blow. The summary tab offers some summary info for the gross,
absorbed, and net damage as well as some options to aggregate by weapon,
monster, attack type etc. 

Two caveats:

* The attack and aim descriptive text for missile weapons are identical, so there's no way for me to easily parse that at the moment.
* If nettdamage is turned on when you parse a log, the "gross" and "net" columns will be identical.

If you find the combat text overwhelming when you have concentrate off, check
out config -> highlight strings. If you uncheck "replace with" and pick one of
your unused windows, you can redirect some of the text. Just make sure that
you've got both windows active in your log settings. You can try out highlight
strings for "and hits for" to get most of the attack strings, and things like
"you are unbalanced", "you are not engaging", and "there is no creature" in order
to keep your main window clear. Check out the "profiles" options to customize
these things on a per-character basis.

If you find a bug, ping Dimly on the Terris Rocket Chat damage discussion
(https://www.legendsofterris.com/rocket/channel/damage_discussion) and I'll see
if I can fix it. I'll probably need a copy of the log file you're trying to
parse to figure out what's going wrong.
