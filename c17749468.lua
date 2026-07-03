--贖罪神女
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,85065943)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65033975,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION+TYPE_SYNCHRO),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.hspcon)
	e2:SetTarget(s.hsptg)
	e2:SetOperation(s.hspop)
	c:RegisterEffect(e2)
	--ind effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(s.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetCondition(s.atkcon)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)
	--cannot activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetValue(s.aclimit)
	c:RegisterEffect(e6)
end
s.material_type=TYPE_SYNCHRO
function s.splimit(e,se,sp,st)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_EXTRA) then return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION end
	return true
end
function s.hspfilter1(c,tp,fc)
	return c:IsFusionCode(85065943)
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0 and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function s.hspfilter2(c,tp,fc)
	return c:IsFaceup() and c:IsReleasable(REASON_MATERIAL|REASON_SPSUMMON)
		and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function s.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroupEx(c:GetControler(),s.hspfilter1,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
		and Duel.IsExistingMatchingCard(s.hspfilter2,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(s.hspfilter1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc1=g1:SelectUnselect(nil,tp,false,true,1,1)
	if tc1 then
		local g2=Duel.GetMatchingGroup(s.hspfilter2,tp,0,LOCATION_MZONE,tc1,tp,c)
		local tc2=g2:SelectUnselect(nil,tp,false,true,1,1)
		if tc2 then
			local mg=Group.CreateGroup()
			mg:AddCard(tc1)
			mg:AddCard(tc2)
			mg:KeepAlive()
			e:SetLabelObject(mg)
			return true
		end
		return false
	else return false end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SPSUMMON|REASON_MATERIAL)
	sg:DeleteGroup()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetFlagEffect(id)~=0
end
function s.atkfilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil,e)
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,id)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttack(0)
end
