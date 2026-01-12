--魔神火焔砲
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsOriginalSetCard(0xde) and c:IsLevelAbove(10) and c:GetFlagEffect(id)==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCost(s.descost)
		e1:SetTarget(s.destg)
		e1:SetOperation(s.desop)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if not tc:IsType(TYPE_EFFECT) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetValue(TYPE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
end
function s.aclimit(e,re,tp)
	local c=re:GetHandler()
	return e:GetLabel()~=c:GetFieldID()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.desfilter(c)
	return c:GetSequence()<5
end
function s.eqfilter(c,tp)
	return c:IsSetCard(0x40) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK+LOCATION_HAND,0,5,nil,tp) end
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(s.desfilter,tp,LOCATION_SZONE,0,nil)==0 then
		local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK+LOCATION_HAND,0,5,5,nil,tp)
		if g:GetCount()>0 then Duel.BreakEffect() end
		for tc in aux.Next(g) do
			if Duel.Equip(tp,tc,c) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(c)
				e1:SetValue(s.eqlimit)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(2000)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetLabel(c:GetFieldID())
	e3:SetValue(s.aclimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
