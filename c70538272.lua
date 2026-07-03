--妖竜の禁姫
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,s.mfilter1,s.mfilter2,true)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.mfilter1(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_FUSION)
end
function s.mfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevelAbove(7)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		loc=loc|LOCATION_ONFIELD
	end
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(loc) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,loc,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=aux.SelectTargetFromFieldFirst(tp,Card.IsAbleToRemove,tp,0,loc,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsPreviousLocation(LOCATION_ONFIELD)
		and (tc:IsLocation(LOCATION_REMOVED) or tc:IsType(TYPE_TOKEN)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.thefilter(c,tp,chk)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and (c:IsAbleToHand() or c:IsAbleToExtra())
		and (Duel.GetMZoneCount(tp,c)>0 or not chk)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thefilter,tp,LOCATION_MZONE,0,1,nil,tp,true)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local rg=nil
	if Duel.IsExistingMatchingCard(s.thefilter,tp,LOCATION_MZONE,0,1,nil,tp,true) then
		rg=Duel.SelectMatchingCard(tp,s.thefilter,tp,LOCATION_MZONE,0,1,1,nil,tp,true)
	else
		rg=Duel.SelectMatchingCard(tp,s.thefilter,tp,LOCATION_MZONE,0,1,1,nil,tp,false)
	end
	if rg and rg:GetCount()>0 then
		Duel.HintSelection(rg)
		if Duel.SendtoHand(rg,nil,REASON_EFFECT)~=0 and rg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND+LOCATION_EXTRA)
			and c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
