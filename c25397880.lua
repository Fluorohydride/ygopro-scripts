--ネフティスの護り手
function c25397880.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25397880,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,25397880)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c25397880.sptg)
	e1:SetOperation(c25397880.spop)
	c:RegisterEffect(e1)
	--reg destroy (deck)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c25397880.spr)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25397880,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,25397881)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c25397880.descon)
	e3:SetTarget(c25397880.destg)
	e3:SetOperation(c25397880.desop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c25397880.spfilter(c,e,tp)
	return c:IsSetCard(0x11f) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(25397880)
end
function c25397880.filter(c,e,tp)
	return Duel.IsExistingMatchingCard(c25397880.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
end
function c25397880.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c25397880.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c25397880.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c25397880.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g==0 then return end
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c25397880.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c25397880.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(r,0x41)~=0x41 then return end
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(25397880,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(25397880,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
	end
end
function c25397880.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(25397880)>0
end
function c25397880.desfilter(c)
	return c:IsSetCard(0x11f) and c:IsType(TYPE_MONSTER) and not c:IsCode(25397880)
end
function c25397880.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c25397880.desfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(c25397880.desfilter,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	c:ResetFlagEffect(25397880)
end
function c25397880.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c25397880.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
