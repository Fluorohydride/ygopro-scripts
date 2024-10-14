--HSR／CWライダー
---@param c Card
function c86154370.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),aux.NonTuner(c86154370.sfilter),1,1)
	--Dice Popboost
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86154370,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DICE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c86154370.destg)
	e1:SetOperation(c86154370.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86154370,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c86154370.spcon)
	e2:SetCost(c86154370.spcost)
	e2:SetTarget(c86154370.sptg)
	e2:SetOperation(c86154370.spop)
	c:RegisterEffect(e2)
end
c86154370.toss_dice=true
c86154370.material_type=TYPE_SYNCHRO
function c86154370.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_SYNCHRO)
end
function c86154370.gyfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToDeck()
end
function c86154370.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c86154370.gyfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c86154370.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local gy=Duel.SelectMatchingCard(tp,c86154370.gyfilter,tp,LOCATION_GRAVE,0,1,dc,nil)
	if #gy==0 then return end
	local yc=Duel.SendtoDeck(gy,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if yc>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(86154370,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,yc,nil)
		Duel.HintSelection(dg)
		local ct=Duel.Destroy(dg,REASON_EFFECT)
		if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
function c86154370.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c86154370.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c86154370.spfilter(c,e,tp,mc)
	return c:IsLevel(7) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c86154370.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c86154370.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c86154370.exfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c86154370.gcheck(g,ft1,ft2)
	return aux.dncheck(g) and #g<=ft1
		and g:FilterCount(c86154370.exfilter,nil)<=ft2
end
function c86154370.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_SYNCHRO)
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	local ct=math.min(ft,ect,2)
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local g=Duel.GetMatchingGroup(c86154370.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c86154370.gcheck,false,1,2,ct,ft2)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
