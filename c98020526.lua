--セイヴァー・ミラージュ
function c98020526.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98020526,3))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--apply
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c98020526.condition)
	e2:SetTarget(c98020526.target)
	e2:SetOperation(c98020526.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(98020526,4))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	c:RegisterEffect(e3)
end
function c98020526.cfilter(c,tp,rp)
	return c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and (c:IsCode(44508094) or c:GetPreviousTypeOnField()&TYPE_SYNCHRO~=0 and aux.IsCodeListed(c,44508094))
		and c:IsReason(REASON_COST+REASON_EFFECT) and rp==tp
end
function c98020526.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98020526.cfilter,1,nil,tp,rp)
end
function c98020526.spfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or (c:IsFaceup() and c:IsLocation(LOCATION_REMOVED))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98020526.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c98020526.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:Filter(c98020526.cfilter,nil,tp,rp):IsExists(c98020526.spfilter,1,nil,e,tp) and Duel.GetFlagEffect(tp,98020526)==0
		local b2=Duel.IsExistingMatchingCard(c98020526.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,98020527)==0
		local b3=Duel.GetFlagEffect(tp,98020528)==0
		return b1 or b2 or b3
	end
end
function c98020526.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:Filter(c98020526.cfilter,nil,tp,rp):IsExists(c98020526.spfilter,1,nil,e,tp) and Duel.GetFlagEffect(tp,98020526)==0
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c98020526.rfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,98020527)==0
	local b3=Duel.GetFlagEffect(tp,98020528)==0
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(98020526,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(98020526,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(98020526,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local sg=eg:Filter(c98020526.cfilter,nil,tp,rp):Filter(c98020526.spfilter,nil,e,tp)
		if #sg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg:Select(tp,1,1,nil)
		end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,98020526,RESET_PHASE+PHASE_END,0,1)
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=aux.SelectCardFromFieldFirst(tp,aux.NecroValleyFilter(c98020526.rfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,98020527,RESET_PHASE+PHASE_END,0,1)
	else
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(c98020526.damval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,98020528,RESET_PHASE+PHASE_END,0,1)
	end
end
function c98020526.damval(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
