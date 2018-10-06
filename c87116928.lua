--キメラテック・メガフリート・ドラゴン
function c87116928.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1093),c87116928.matfilter,1,63,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c87116928.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c87116928.sprcon)
	e2:SetOperation(c87116928.sprop)
	c:RegisterEffect(e2)
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
c87116928.material_setcode=0x1093
function c87116928.matfilter(c)
	return c:GetSequence()>4
end
function c87116928.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c87116928.cfilter(c,tp)
	return (c:IsFusionSetCard(0x1093) or c:GetSequence()>4) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function c87116928.fcheck(c,sg)
	return c:IsFusionSetCard(0x1093) and c:IsType(TYPE_MONSTER) and sg:FilterCount(c87116928.fcheck2,c)+1==sg:GetCount()
end
function c87116928.fcheck2(c)
	return c:GetSequence()>4
end
function c87116928.fgoal(c,tp,sg)
	return #sg>1 and #sg<=3 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c87116928.fcheck,1,nil,sg)
end
function c87116928.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c87116928.fgoal(c,tp,sg) or mg:IsExists(c87116928.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c87116928.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c87116928.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c87116928.fselect,1,nil,tp,mg,sg)
end
function c87116928.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c87116928.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c87116928.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c87116928.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	Duel.SendtoGrave(sg,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(sg:GetCount()*1200)
	c:RegisterEffect(e1)
end
