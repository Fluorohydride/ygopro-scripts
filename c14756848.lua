--超重武者ヌス－10
---@param c Card
function c14756848.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14756848,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c14756848.hspcon)
	e1:SetOperation(c14756848.hspop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c14756848.descost)
	e2:SetTarget(c14756848.destg)
	e2:SetOperation(c14756848.desop)
	c:RegisterEffect(e2)
end
function c14756848.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c14756848.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c14756848.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function c14756848.hspop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c14756848.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c14756848.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9a)
end
function c14756848.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c14756848.desfilter1(c)
	return c:GetSequence()<5
end
function c14756848.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c14756848.desfilter1,tp,0,LOCATION_SZONE,1,nil) then sel=sel+1 end
		if Duel.GetFieldGroupCount(tp,0,LOCATION_PZONE)>0 then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(14756848,1),aux.Stringid(14756848,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(14756848,1))
	else
		Duel.SelectOption(tp,aux.Stringid(14756848,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		local g=Duel.GetMatchingGroup(c14756848.desfilter1,tp,0,LOCATION_SZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		local g=Duel.GetFieldGroup(tp,0,LOCATION_PZONE)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c14756848.desop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c14756848.desfilter1,tp,0,LOCATION_SZONE,1,1,nil)
		local tc=g:GetFirst()
		if not tc then return end
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and not tc:IsLocation(LOCATION_HAND+LOCATION_DECK)
			and tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable()
			and Duel.SelectYesNo(tp,aux.Stringid(14756848,3)) then
			Duel.BreakEffect()
			Duel.SSet(tp,tc)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_PZONE):Select(tp,1,1,nil)
		local tc=g:GetFirst()
		if not tc then return end
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0
			and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
			and not tc:IsLocation(LOCATION_HAND+LOCATION_DECK) and not tc:IsForbidden()
			and Duel.SelectYesNo(tp,aux.Stringid(14756848,4)) then
			Duel.BreakEffect()
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
