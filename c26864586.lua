--共振装置
function c26864586.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26864586.target)
	e1:SetOperation(c26864586.activate)
	c:RegisterEffect(e1)
end
function c26864586.filter(c,e)
	return c:IsFaceup() and c:IsHasLevel() and c:IsCanBeEffectTarget(e)
end
function c26864586.fselect(g)
	return aux.SameValueCheck(g,Card.GetAttribute) and aux.SameValueCheck(g,Card.GetRace) and aux.dlvcheck(g)
end
function c26864586.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c26864586.filter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c26864586.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,c26864586.fselect,false,2,2)
	Duel.SetTargetCard(tg)
end
function c26864586.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:FilterCount(Card.IsFaceup,nil)<2 or not aux.dlvcheck(g) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26864586,0))
	local tc2=g:Select(tp,1,1,nil):GetFirst()
	local tc1=g:GetFirst()
	if tc1==tc2 then tc1=g:GetNext() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(tc1:GetLevel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc2:RegisterEffect(e1)
end
