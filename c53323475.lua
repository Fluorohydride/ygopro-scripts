--傀儡流儀－パペット・シャーク
local s,id,o=GetID()
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 end
end
function s.thfilter(c,tp)
	return c:IsType(TYPE_TRAP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		or c:IsType(TYPE_MONSTER+TYPE_SPELL) and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_EFFECT)~=0 then
		Duel.ConfirmDecktop(tp,4)
		local g=Duel.GetDecktopGroup(tp,4):Filter(s.thfilter,nil,tp)
		if #g>0 then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			Duel.RevealSelectDeckSequence(true)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.RevealSelectDeckSequence(false)
			if sc:IsType(TYPE_TRAP) then
				if Duel.SSet(tp,sc)>0 then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(id,1))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1)
				end
			else
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
				Duel.ShuffleHand(tp)
			end
		end
	end
end
