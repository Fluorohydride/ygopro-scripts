--ミュートリア超個体系
---@param c Card
function c60967717.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60967717+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetOperation(c60967717.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c60967717.reptg)
	e2:SetValue(c60967717.repval)
	e2:SetOperation(c60967717.repop)
	c:RegisterEffect(e2)
end
function c60967717.filter(c,e,tp,ft)
	return c:IsSetCard(0x157) and c:IsLevelBelow(4)
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c60967717.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c60967717.filter,tp,LOCATION_DECK,0,nil,e,tp,ft)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60967717,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local opt=0
		if not tc:IsAbleToHand() then
			opt=1
		elseif not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 then
			opt=0
		else
			opt=Duel.SelectOption(tp,1190,1152)
		end
		if opt==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c60967717.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x157) and c:IsLocation(LOCATION_MZONE) and c:IsLevelAbove(8)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c60967717.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c60967717.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c60967717.repval(e,c)
	return c60967717.repfilter(c,e:GetHandlerPlayer())
end
function c60967717.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
