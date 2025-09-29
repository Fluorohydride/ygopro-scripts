--恋する乙女
local s,id,o=GetID()
function s.initial_effect(c)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e2:SetValue(s.atklimit)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--con or cou
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_CONTROL+CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(s.cccon)
	e4:SetTarget(s.cctg)
	e4:SetOperation(s.ccop)
	c:RegisterEffect(e4)
end
s.counter_add_list={0x1072}
function s.atklimit(e,c)
	return c==e:GetHandler()
end
function s.cccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end
function s.cfilter(c)
	return c:IsControlerCanBeChanged() and c:GetCounter(0x1072)>0
end
function s.cctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1072,1)
	local b2=Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,3),1},
			{b2,aux.Stringid(id,4),2})
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_COUNTER)
		local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1072,1)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
	elseif op==2 then
		e:SetCategory(CATEGORY_CONTROL)
		local g=Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
end
function s.ccop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local g=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1072,1)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			tc:AddCounter(0x1072,1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			Duel.GetControl(tc,tp)
		end
	end
end
