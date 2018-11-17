--氷獄龍 トリシューラ
function c15661378.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c15661378.ffilter,3,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c15661378.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c15661378.spcon)
	e2:SetOperation(c15661378.spop)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15661378,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,15661378)
	e3:SetCondition(c15661378.remcon)
	e3:SetTarget(c15661378.remtg)
	e3:SetOperation(c15661378.remop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c15661378.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c15661378.ffilter(c,fc,sub,mg,sg)
	return c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c15661378.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
		or st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function c15661378.cfilter(c,fc)
	return c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc)
end
function c15661378.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c15661378.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:GetClassCount(Card.GetFusionCode)==3
	end
	sg:RemoveCard(c)
	return res
end
function c15661378.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c15661378.cfilter,tp,LOCATION_MZONE,0,nil,c)
	local sg=Group.CreateGroup()
	return mg:IsExists(c15661378.fselect,1,nil,tp,mg,sg)
end
function c15661378.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c15661378.cfilter,tp,LOCATION_MZONE,0,nil,c)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c15661378.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c15661378.mfilter(c)
	return c:GetOriginalRace()~=RACE_DRAGON
end
function c15661378.valcheck(e,c)
	local mg=c:GetMaterial()
	if not mg:IsExists(c15661378.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c15661378.remcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 or c:IsSummonType(SUMMON_TYPE_FUSION)) and e:GetLabel()==1
end
function c15661378.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK+LOCATION_EXTRA)
end
function c15661378.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.ConfirmDecktop(1-tp,1)
		Duel.ConfirmCards(tp,g3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:Select(tp,1,1,nil)
		sg1:Merge(g2)
		sg1:Merge(sg3)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	end
end
