--誇大化
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local b1=a:IsCanChangePosition() and a:IsAttackPos()
	local b2=d and d:IsAbleToHand()
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)},
		{true,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,a,1,0,0)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,d,1,0,0)
	else
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,Group.FromCards(a,d),2,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		s.defense(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		s.rtohand(e,tp,eg,ep,ev,re,r,rp)
	elseif op==3 then
		s.destroy(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.defense(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() then Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) end
end
function s.rtohand(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if tc:IsRelateToBattle() then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
function s.destroy(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	local g=Group.FromCards(a,d):Filter(Card.IsRelateToBattle,nil)
	if #g==2 then Duel.Destroy(g,REASON_EFFECT) end
end
