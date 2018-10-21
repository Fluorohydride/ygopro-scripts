--E・HERO コスモ・ネオス
function c90050480.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,89943723,c90050480.ffilter,3,true,true)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c90050480.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c90050480.sprcon)
	e2:SetOperation(c90050480.sprop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90050480,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90050480.retcon1)
	e3:SetTarget(c90050480.rettg)
	e3:SetOperation(c90050480.retop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0)
	e4:SetCondition(c90050480.retcon2)
	c:RegisterEffect(e4)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(90050480,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c90050480.limcon)
	e5:SetTarget(c90050480.limtg)
	e5:SetOperation(c90050480.limop)
	c:RegisterEffect(e5)
end
c90050480.material_setcode=0x8
c90050480.card_code_list={89943723}
function c90050480.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x1f) and (not sg or not sg:Filter(Card.IsFusionSetCard,nil,0x1f):IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c90050480.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c90050480.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c90050480.sprfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
end
function c90050480.sprfilter1(c,tp,fc)
	return c:IsFusionCode(89943723) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c90050480.sprfilter2,tp,LOCATION_MZONE,0,1,c,tp,fc,c)
end
function c90050480.sprfilter2(c,tp,fc,mc)
	return c:IsFusionSetCard(0x1f) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c90050480.sprfilter3,tp,LOCATION_MZONE,0,1,Group.FromCards(c,mc),tp,fc,mc,c)
end
function c90050480.sprfilter3(c,tp,fc,mc1,mc2)
	return c:IsFusionSetCard(0x1f) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionAttribute(mc2:GetFusionAttribute())
		and Duel.IsExistingMatchingCard(c90050480.sprfilter4,tp,LOCATION_MZONE,0,1,Group.FromCards(c,mc1,mc2),tp,fc,mc1,mc2,c)
end
function c90050480.sprfilter4(c,tp,fc,mc1,mc2,mc3)
	local g=Group.FromCards(c,mc1,mc2,mc3)
	return c:IsFusionSetCard(0x1f) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionAttribute(mc2:GetFusionAttribute()) and not c:IsFusionAttribute(mc3:GetFusionAttribute())
		and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c90050480.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c90050480.sprfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c90050480.sprfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=Duel.SelectMatchingCard(tp,c90050480.sprfilter3,tp,LOCATION_MZONE,0,1,1,Group.FromCards(g1:GetFirst(),g2:GetFirst()),tp,c,g1:GetFirst(),g2:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g4=Duel.SelectMatchingCard(tp,c90050480.sprfilter4,tp,LOCATION_MZONE,0,1,1,Group.FromCards(g1:GetFirst(),g2:GetFirst(),g3:GetFirst()),tp,c,g1:GetFirst(),g2:GetFirst(),g3:GetFirst())
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	local cg=g1:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c90050480.retcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(42015635)
end
function c90050480.retcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(42015635)
end
function c90050480.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c90050480.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c90050480.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function c90050480.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c90050480.chainlm)
end
function c90050480.chainlm(e,rp,tp)
	return tp==rp
end
function c90050480.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c90050480.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90050480.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
