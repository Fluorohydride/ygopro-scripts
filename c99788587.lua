--爆導索
function c99788587.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c99788587.condition)
	e1:SetTarget(c99788587.target)
	e1:SetOperation(c99788587.activate)
	c:RegisterEffect(e1)
end
function c99788587.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAllColumn()
end
function c99788587.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local g=e:GetHandler():GetColumnGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99788587.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetColumnGroup()
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
