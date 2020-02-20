--剣の王 フローディ
function c40998517.initial_effect(c)
	c:SetUniqueOnField(1,0,40998517)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40998517,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40998517)
	e1:SetCost(c40998517.descost)
	e1:SetTarget(c40998517.destg)
	e1:SetOperation(c40998517.desop)
	c:RegisterEffect(e1)
end
function c40998517.costfilter(c,tp)
	return (c:IsSetCard(0x134) or c:IsRace(RACE_WARRIOR))
		and Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c40998517.fselect(g,tp)
	return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,g:GetCount(),g)
		and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function c40998517.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c40998517.costfilter,1,nil,tp) end
	local rg=Duel.GetReleaseGroup(tp):Filter(c40998517.costfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c40998517.fselect,false,1,rg:GetCount(),tp)
	local ct=Duel.Release(sg,REASON_COST)
	e:SetLabel(ct)
end
function c40998517.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c40998517.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(tg,REASON_EFFECT)==0 then return end
	local ct=Duel.GetOperatedGroup():FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,1-tp),nil)
	if ct>0 and Duel.IsPlayerCanDraw(1-tp,ct) and Duel.SelectYesNo(1-tp,aux.Stringid(40998517,1)) then
		Duel.BreakEffect()
		Duel.Draw(1-tp,ct,REASON_EFFECT)
	end
end
