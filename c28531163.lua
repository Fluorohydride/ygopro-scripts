--黙歯録
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x6f)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return ct>0 and Duel.IsCanAddCounter(tp,0x6f,ct,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x6f)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if c:IsRelateToChain() and ct>0 then
		c:AddCounter(0x6f,ct)
	end
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x6f,1,REASON_COST)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	local b1=Duel.IsCanRemoveCounter(tp,1,0,0x6f,1,REASON_COST)
	local b2=Duel.IsCanRemoveCounter(tp,1,0,0x6f,2,REASON_COST) and not tc:IsAttack(0)
	local b3=Duel.IsCanRemoveCounter(tp,1,0,0x6f,3,REASON_COST) and aux.NegateEffectMonsterFilter(tc)
	local b4=Duel.IsCanRemoveCounter(tp,1,0,0x6f,4,REASON_COST)
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2},
			{b3,aux.Stringid(id,3),3},
			{b4,aux.Stringid(id,4),4})
	Duel.RemoveCounter(tp,1,0,0x6f,op,REASON_COST)
	e:SetLabel(op)
	if op==1 or op==2 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	elseif op==3 then
		e:SetCategory(CATEGORY_DISABLE)
	elseif op==4 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToChain() or not tc:IsType(TYPE_MONSTER) then return end
	if e:GetLabel()==1 then
		if tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-500)
			tc:RegisterEffect(e1)
		end
	elseif e:GetLabel()==2 then
		if tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	elseif e:GetLabel()==3 then
		if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	elseif e:GetLabel()==4 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
