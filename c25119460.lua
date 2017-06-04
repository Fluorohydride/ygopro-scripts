--YZ－キャタピラー・ドラゴン
function c25119460.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,65622692,64500000,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c25119460.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c25119460.spcon)
	e2:SetOperation(c25119460.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25119460,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c25119460.descost)
	e3:SetTarget(c25119460.destg)
	e3:SetOperation(c25119460.desop)
	c:RegisterEffect(e3)
end
function c25119460.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA+LOCATION_GRAVE)
end
function c25119460.matfilter(c)
	return c:IsFusionCode(65622692,64500000) and c:IsAbleToRemoveAsCost()
end
function c25119460.spfilter1(c,tp,g)
	return g:IsExists(c25119460.spfilter2,1,c,tp,c)
end
function c25119460.spfilter2(c,tp,mc)
	return (c:IsFusionCode(65622692) and mc:IsFusionCode(64500000)
		or c:IsFusionCode(64500000) and mc:IsFusionCode(65622692))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c25119460.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c25119460.matfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:IsExists(c25119460.spfilter1,1,nil,tp,g)
end
function c25119460.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c25119460.matfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c25119460.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:FilterSelect(tp,c25119460.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c25119460.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c25119460.filter(c)
	return c:IsFacedown()
end
function c25119460.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c25119460.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25119460.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c25119460.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c25119460.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
