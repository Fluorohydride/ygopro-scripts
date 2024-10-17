--スプリガンズ・インタールーダー
---@param c Card
function c25415161.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25415161,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,25415161)
	e1:SetCondition(c25415161.condition)
	e1:SetTarget(c25415161.target)
	e1:SetOperation(c25415161.activate)
	c:RegisterEffect(e1)
	--attack down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25415161,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,25415162)
	e2:SetCondition(c25415161.atkcon)
	e2:SetTarget(c25415161.atktg)
	e2:SetOperation(c25415161.atkop)
	c:RegisterEffect(e2)
end
function c25415161.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c25415161.spfilter(c,e,tp)
	return c:IsLevel(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25415161.spsfilter(c,e,tp,solve)
	if solve then
		return aux.NecroValleyFilter(c25415161.spfilter)(c,e,tp)
	else
		return c25415161.spfilter(c,e,tp)
	end
end
function c25415161.tefilter(c,e,tp,ev,solve1,solve2)
	return c:IsFaceup() and c:IsSetCard(0x155) and c:IsType(TYPE_XYZ) and c:IsAbleToExtra()
		and (solve1 or (Duel.IsChainDisablable(ev) or Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c25415161.spsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,solve2)))
end
function c25415161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25415161.tefilter,tp,LOCATION_MZONE,0,1,nil,e,tp,ev) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c25415161.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c25415161.tefilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ev,false,true):GetFirst()
	if not tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		tc=Duel.SelectMatchingCard(tp,c25415161.tefilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ev,true,true):GetFirst()
	end
	if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
		if not Duel.IsChainDisablable(ev) and not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c25415161.spsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,true)) then
			return
		end
		Duel.BreakEffect()
		if Duel.IsChainDisablable(ev) and (Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			or not Duel.IsExistingMatchingCard(c25415161.spsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,true)
			or Duel.SelectOption(tp,aux.Stringid(25415161,2),1152)==0) then
			Duel.NegateEffect(ev)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c25415161.spsfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,true)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c25415161.atkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousTypeOnField()&TYPE_XYZ~=0
		and c:IsReason(REASON_EFFECT)
end
function c25415161.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c25415161.atkfilter,1,nil,tp)
end
function c25415161.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c25415161.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
