--混源龍レヴィオニア
---@param c Card
function c55878038.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55878038,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c55878038.spcon)
	e1:SetTarget(c55878038.sptg)
	e1:SetOperation(c55878038.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--Destroy/Shuffle/Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,55878038)
	e2:SetCondition(c55878038.descon)
	e2:SetTarget(c55878038.destg)
	e2:SetOperation(c55878038.desop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c55878038.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c55878038.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	return Duel.IsExistingMatchingCard(c55878038.spcostfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c55878038.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c55878038.spcostfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:CancelableSelect(tp,3,3,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c55878038.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local label=0
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) then
		label=label+1
	end
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) then
		label=label+2
	end
	e:SetLabel(label)
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c55878038.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c55878038.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c55878038.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local label=e:GetLabelObject():GetLabel()
	if chk==0 then
		if label==1 then
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(c55878038.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		elseif label==2 then
			return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		else
			return true
		end
	end
	e:SetLabel(label)
	if label==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(55878038,1))
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif label==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(55878038,2))
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(55878038,3))
		e:SetCategory(CATEGORY_DESTROY)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c55878038.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local label=e:GetLabel()
	if label==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c55878038.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	elseif label==2 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=0 then return end
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		local g3=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g3:GetCount()>0 then
			local ct=math.min(g3:GetCount(),2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g3:Select(tp,1,ct,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
