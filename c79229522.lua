--キメラテック・フォートレス・ドラゴン
function c79229522.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,70095154,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79229522.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c79229522.sprcon)
	e2:SetOperation(c79229522.sprop)
	c:RegisterEffect(e2)
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c79229522.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c79229522.cfilter(c,tp)
	return (c:IsFusionCode(70095154) or c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function c79229522.fcheck(c,sg)
	return c:IsFusionCode(70095154) and sg:FilterCount(c79229522.fcheck2,c)+1==sg:GetCount()
end
function c79229522.fcheck2(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER)
end
function c79229522.fgoal(c,tp,sg)
	return sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c79229522.fcheck,1,nil,sg)
end
function c79229522.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c79229522.fgoal(c,tp,sg) or mg:IsExists(c79229522.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c79229522.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c79229522.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c79229522.fselect,1,nil,tp,mg,sg)
end
function c79229522.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c79229522.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c79229522.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c79229522.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
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
	e1:SetValue(sg:GetCount()*1000)
	c:RegisterEffect(e1)
end
