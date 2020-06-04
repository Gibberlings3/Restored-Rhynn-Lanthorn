// redirect the link to the 'stole the Lanthorn' block so it only fires if we don't have any lenses to find

ADD_TRANS_TRIGGER c6elhan2 34 ~Global("dw_lens_alloc","GLOBAL",0)~
EXTEND_BOTTOM c6elhan2 34 
IF ~GlobalGT("dw_lens_alloc","GLOBAL",1)~ THEN GOTO need_multiple_lenses 
IF ~!GlobalGT("dw_lens_alloc","GLOBAL",1)~ THEN GOTO need_single_lens  
END

// add the new Elhan blocks

APPEND c6elhan2

IF ~~ THEN BEGIN need_multiple_lenses
SAY @1 /*~Our sages have found signs of the Lanthorn in several places in human lands. We suspect that the thief has disassembled the artifact and hidden its lenses. But as for that thief, the sages have not been able to divine where they went, despite their best efforts.~*/ 
IF ~~ THEN GOTO 36_clone
END


IF ~~ THEN BEGIN need_single_lens
SAY @2 /*~Our sages have found a trace of the Lanthorn in human lands, but the magical signature is weak. We suspect that the thief has removed a lens from the Lanthorn and hidden it. But as for that thief, the sages have not been able to divine where they went, despite their best efforts.~*/ 
IF ~~ THEN GOTO 36_clone
END

IF ~~ THEN BEGIN 36_clone
SAY @3 /*~It is clear, in any case, that our worst fears are confirmed, and the Lanthorn is no longer in elven territory.~*/ 
COPY_TRANS c6elhan2 36
END

IF ~~ THEN BEGIN elhan_exit // exit from lens chat
SAY @18 /*~That is all we have learned. We cannot intervene in human lands - <CHARNAME>, we must rely on you for this also.~*/
COPY_TRANS c6elhan2 47
END

END


// now redirect 47 into the lens conversation (we have to do it here and not earlier, since we COPY_TRANS 47)

ADD_TRANS_TRIGGER c6elhan2 47 ~Global("dw_lens_alloc","GLOBAL",0)~
EXTEND_BOTTOM c6elhan2 47 
IF ~Global("dw_lens_alloc","GLOBAL",1)~ THEN UNSOLVED_JOURNAL #57944 GOTO quest_single_lens
IF ~Global("dw_lens_alloc","GLOBAL",2)~ THEN UNSOLVED_JOURNAL #54686 GOTO quest_two_lenses
IF ~Global("dw_lens_alloc","GLOBAL",3)~ THEN UNSOLVED_JOURNAL #57940 GOTO quest_three_lenses
END

// the various blocks that handle sage advice

APPEND c6warsa2
IF ~~ THEN BEGIN elhan_comment_1
SAY @11 /*We can be no more specific than this.*/
IF ~Global("dw_lens_alloc","GLOBAL",1)~ THEN EXTERN c6elhan2 elhan_exit
IF ~!Global("dw_lens_alloc","GLOBAL",1)~ THEN DO ~IncrementGlobal("dw_sage_count","MYAREA",1)~ EXTERN c6elhan2  elhan_line_2
END

IF ~~ THEN BEGIN elhan_comment_2
SAY @13 /*~I hope this has meaning for you, <CHARNAME>.~*/
IF ~Global("dw_lens_alloc","GLOBAL",2)~ THEN EXTERN c6elhan2  elhan_exit
IF ~!Global("dw_lens_alloc","GLOBAL",2)~ THEN DO ~IncrementGlobal("dw_sage_count","MYAREA",1)~ EXTERN c6elhan2  elhan_line_3
END

END


APPEND_EARLY c6elhan2
IF ~~ THEN BEGIN quest_three_lenses
SAY @17 /*~And there remains the matter of the missing lenses. Here we know a little, through the divinations of the sages. But our advice is cryptic, as such divinations always are. Sage - tell <CHARNAME> what you have learned of the first lens.~*/
/*
IF ~Global("PlayerToldOfTrollMound","GLOBAL",1)Global("dw_trolls","LOCALS",0)~ THEN DO ~SetGlobal("dw_trolls","LOCALS",1)~ EXTERN c6warsa1 sage_trolls
IF ~Global("PlayerToldOfUnseeingEye","GLOBAL",1)Global("dw_unseeing","LOCALS",0)~ THEN DO ~SetGlobal("dw_unseeing","LOCALS",1)~ EXTERN c6warsa1 sage_unseeing
IF ~Global("PlayerToldOfTorgal","GLOBAL",1)Global("dw_torgal","LOCALS",0)~ THEN DO ~SetGlobal("dw_torgal","LOCALS",1)~ EXTERN c6warsa1 sage_torgal
IF ~Global("PlayerToldOfSamia","GLOBAL",1)Global("dw_samia","LOCALS",0)~ THEN DO ~SetGlobal("dw_samia","LOCALS",1)~ EXTERN c6warsa1 sage_samia
IF ~Global("PlayerToldOfMaevar","GLOBAL",1)Global("dw_maevar","LOCALS",0)~ THEN DO ~SetGlobal("dw_maevar","LOCALS",1)~ EXTERN c6warsa1 sage_maevar
IF ~Global("PlayerToldOfMekrath","GLOBAL",1)Global("dw_mekrath","LOCALS",0)~ THEN DO ~SetGlobal("dw_mekrath","LOCALS",1)~ EXTERN c6warsa1 sage_mekrath
IF ~Global("PlayerToldOfShadeLord","GLOBAL",1)Global("dw_shade_lord","LOCALS",0)~ THEN DO ~SetGlobal("dw_shade_lord","LOCALS",1)~ EXTERN c6warsa1 sage_shadelord
*/
END


IF ~~ THEN BEGIN quest_two_lenses
SAY @17 /*~And there remains the matter of the missing lenses. Here we know a little, through the divinations of the sages. But our advice is cryptic, as such divinations always are. Sage - tell <CHARNAME> what you have learned of the first lens.~*/
//COPY_TRANS_LATE c6elhan2 quest_three_lenses
END

IF ~~ THEN BEGIN quest_single_lens
SAY @16 /*And there remains the matter of the missing lens. Here we know a little, through the divinations of the sages. But our advice is cryptic, as such divinations always are. Sage - tell <CHARNAME> what you have learned.~*/
//COPY_TRANS_LATE c6elhan2 quest_three_lenses
END

IF ~~ THEN BEGIN elhan_comment_3
SAY @15 /*~I'm sorry this is unclear, but I think sages make a habit of being confusing on purpose.~*/
IF ~~ THEN GOTO elhan_exit
END

IF ~~ THEN BEGIN elhan_line_2
SAY @12 /*~Sage, tell <CHARNAME> the second of the divinations.~*/
//COPY_TRANS_LATE c6elhan2 quest_three_lenses
END

IF ~~ THEN BEGIN elhan_line_3
SAY @14 /*~Sage, speak the last divination.~*/
//COPY_TRANS_LATE c6elhan2 quest_three_lenses
END

END

// mention of the lenses if you return without the Lanthorn

EXTEND_BOTTOM c6elhan2 65
IF ~Global("dw_lens_alloc","GLOBAL",1)PartyHasItem("c6lens")~ THEN GOTO need_1_have_1
IF ~Global("dw_lens_alloc","GLOBAL",2)NumItemsParty("c6lens",2)~ THEN GOTO need_some_have_some
IF ~Global("dw_lens_alloc","GLOBAL",3)NumItemsParty("c6lens",3)~ THEN GOTO need_some_have_some
IF ~Global("dw_lens_alloc","GLOBAL",2)!NumItemsParty("c6lens",2)~ THEN GOTO need_some_have_fewer
IF ~Global("dw_lens_alloc","GLOBAL",3)!NumItemsParty("c6lens",3)~ THEN GOTO need_some_have_fewer
IF ~Global("dw_lens_alloc","GLOBAL",1)!PartyHasItem("c6lens")~ THEN GOTO need_1_have_0
IF ~Global("dw_lens_alloc","GLOBAL",2)!PartyHasItem("c6lens")~ THEN GOTO need_2_have_0
IF ~Global("dw_lens_alloc","GLOBAL",3)!PartyHasItem("c6lens")~ THEN GOTO need_3_have_0
END

APPEND c6elhan2

IF ~~ THEN BEGIN need_1_have_1
SAY @21 /*The sages tell me that you have recovered the missing lens - I congratulate you, but without the Lanthorn, all your efforts will be in vain.*/
IF ~~ THEN EXIT
END

IF ~~ THEN BEGIN need_some_have_some
SAY @19 /*The sages tell me that you have recovered all of the missing lenses - I congratulate you, but without the Lanthorn, all your efforts will be in vain.*/
IF ~~ THEN EXIT
END

IF ~~ THEN BEGIN need_some_have_fewer
SAY @20 /*The sages tell me that you have recovered some of the missing lenses - I congratulate you, but without the Lanthorn and the remaining lenses, all your efforts will be in vain.*/
IF ~~ THEN EXIT
END

IF ~~ THEN BEGIN need_3_have_0
SAY @22 /*Remember, too, that three of the Lanthorn's lenses are hidden somewhere in Amn. They, too, must be recovered if we are to prevail against Irenicus.*/
IF ~~ THEN EXIT
END

IF ~~ THEN BEGIN need_2_have_0
SAY @23 /*Remember, too, that two of the Lanthorn's lenses are hidden somewhere in Amn. They, too, must be recovered if we are to prevail against Irenicus.*/
IF ~~ THEN EXIT
END

IF ~~ THEN BEGIN need_1_have_0
SAY @24 /*Remember, too, that one of the Lanthorn's lenses is hidden somewhere in Amn. It, too, must be recovered if we are to prevail against Irenicus.*/
IF ~~ THEN EXIT
END
END

// handle the lenses if you have found the Lanthorn

ADD_TRANS_TRIGGER c6elhan2 74 ~Global("dw_lens_alloc","GLOBAL",0)~
EXTEND_BOTTOM c6elhan2 74
IF ~!Global("dw_lens_alloc","GLOBAL",0)~ THEN GOTO demin_alternate
END

APPEND c6elhan2
IF ~~ THEN BEGIN demin_alternate
SAY @25 /*Demin the high priestess, she will tell you. But we will have to breach the city to find her.*/
IF ~Global("dw_lens_alloc","GLOBAL",1)PartyHasItem("c6lens")~ THEN GOTO reassemble_1_lens
IF ~Global("dw_lens_alloc","GLOBAL",1)!PartyHasItem("c6lens")~ THEN GOTO still_missing_lens
IF ~Global("dw_lens_alloc","GLOBAL",2)NumItemsParty("c6lens",2)~ THEN GOTO reassemble_some_lenses
IF ~Global("dw_lens_alloc","GLOBAL",3)NumItemsParty("c6lens",3)~ THEN GOTO reassemble_some_lenses
IF ~Global("dw_lens_alloc","GLOBAL",2)!NumItemsParty("c6lens",2)~ THEN GOTO still_missing_lenses
IF ~Global("dw_lens_alloc","GLOBAL",3)!NumItemsParty("c6lens",3)~ THEN GOTO still_missing_lenses
END

IF ~~ THEN BEGIN reassemble_1_lens
SAY @28 /*Fortunately, I see that you have recovered the lost lens. With it restored, the Lanthorn is complete - and my sages have instructed me in its use.*/
IF ~~ THEN DO ~TakePartyItem("c6lens")TakePartyItem("c6lens")TakePartyItem("c6lens")~ GOTO 79
END

IF ~~ THEN BEGIN reassemble_some_lenses
SAY @29 /*Fortunately, I see that you have recovered the lost lenses. With these restored, the Lanthorn is complete - and my sages have instructed me in its use.*/
IF ~~ THEN DO ~TakePartyItem("c6lens")TakePartyItem("c6lens")TakePartyItem("c6lens")~ GOTO 79
END

IF ~~ THEN BEGIN still_missing_lenses
SAY @26 /*Unfortunately, our fears are confirmed - some of the Lanthorn's lenses have been removed, and without them, its magic cannot pierce the veil that Irenicus has placed around Suldenesselar. Redouble your efforts, <CHARNAME> - we must have those lenses. Return to me as soon as you have found them.*/
IF ~~ THEN DO ~SetGlobal("dw_still_missing_lenses","MYAREA",1)~ UNSOLVED_JOURNAL @120 EXIT
END


IF ~~ THEN BEGIN still_missing_lens
SAY @27 /*Unfortunately, our fears are confirmed - one of the Lanthorn's lenses has been removed, and without that lens, its magic cannot pierce the veil that Irenicus has placed around Suldenesselar. Redouble your efforts, <CHARNAME> - we must have that lens. Return to me as soon as you have found it.*/
IF ~~ THEN DO ~SetGlobal("dw_still_missing_lenses","MYAREA",1)~ UNSOLVED_JOURNAL @121 EXIT
END

END

// handle a possible subsequent return with the lenses

ADD_STATE_TRIGGER c6elhan2 64 ~Global("dw_still_missing_lenses","MYAREA",0)~

APPEND c6elhan2

IF ~Global("ElvenCityTree","GLOBAL",0)!Global("dw_still_missing_lenses","MYAREA",0)~ THEN BEGIN return_after_lanthorn
SAY @30 /*You return once again. The drow have grown restive, though we have defeated every war party they have sent against us. But Suldanesselar remains lost to us, and with each night my fear grows for its people.*/
IF ~Global("dw_lens_alloc","GLOBAL",1)PartyHasItem("c6lens")~ THEN GOTO return_with_lens
IF ~Global("dw_lens_alloc","GLOBAL",1)!PartyHasItem("c6lens")~ THEN GOTO return_without_lens
IF ~Global("dw_lens_alloc","GLOBAL",2)NumItemsParty("c6lens",2)~ THEN GOTO return_with_lenses
IF ~Global("dw_lens_alloc","GLOBAL",3)NumItemsParty("c6lens",3)~ THEN GOTO return_with_lenses
IF ~Global("dw_lens_alloc","GLOBAL",2)!NumItemsParty("c6lens",2)~ THEN GOTO return_without_lenses
IF ~Global("dw_lens_alloc","GLOBAL",3)!NumItemsParty("c6lens",3)~ THEN GOTO return_without_lenses
END

IF ~~ THEN BEGIN return_with_lens
SAY @31/* ~You have the lens we need! Quickly, <CHARNAME>, give it to me - the sages have told me how to repair the Lanthorn, and how to use it.~*/
IF ~~ THEN DO ~TakePartyItem("c6lens")TakePartyItem("c6lens")TakePartyItem("c6lens")~ GOTO 79
END

IF ~~ THEN BEGIN return_with_lenses
SAY @32 /*~You have the lenses we need! Quickly, <CHARNAME>, give them to me - the sages have told me how to repair the Lanthorn, and how to use it.~*/
IF ~~ THEN DO ~TakePartyItem("c6lens")TakePartyItem("c6lens")TakePartyItem("c6lens")~ GOTO 79
END

IF ~~ THEN BEGIN return_without_lenses
SAY @33 /*And yet, my sages tell me that you have not recovered the lenses we seek. Make haste - the plight of the elves grows worse with each passing day.*/
IF ~~ THEN EXIT
END

IF ~~ THEN BEGIN return_without_lens
SAY @34  /*And yet, my sages tell me that you have not recovered the lens we seek. Make haste - the plight of the elves grows worse with each passing day.*/
IF ~~ THEN EXIT
END

END

// move vanilla journal entry somewhere it will occur before the lens entry

ALTER_TRANS c6elhan2 BEGIN 46 END BEGIN 0 END BEGIN "UNSOLVED_JOURNAL" ~#57914~ END

// debug 

ADD_TRANS_TRIGGER c6elhan2 79 ~Global("dw_truncate_elhan","GLOBAL",0)~
EXTEND_BOTTOM c6elhan2 79
IF ~!Global("dw_truncate_elhan","GLOBAL",0)~ THEN REPLY ~Exiting Elhan conversation. (Debug: should not appear in live play.)~ EXIT
END
