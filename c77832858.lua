--邪炎帝王テスタロス
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--tribute from each field for advance summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.otcon)
	e1:SetOperation(s.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(s.mchk)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetLabelObject(e3)
	e4:SetCondition(s.rmcon)
	e4:SetTarget(s.rmtg)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
end
function s.tfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsControler(tp)
end
function s.tcheck(g,tp)
	return g:IsExists(s.tfilter,1,nil,tp) and g:IsExists(Card.IsControler,1,nil,1-tp)
		and Duel.GetMZoneCount(tp,g)>0
end
function s.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,nil,REASON_SUMMON)
	return c:IsLevelAbove(7) and minc<=2 and g:CheckSubGroup(s.tcheck,2,2,tp)
end
function s.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,nil,REASON_SUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,s.tcheck,false,2,2,tp)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_MATERIAL+REASON_SUMMON)
end
function s.mfilter(c)
	return c:IsLevelAbove(8) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.mchk(e,c)
	if c:GetMaterial():IsExists(s.mfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function s.rmcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	e:SetLabel(e:GetLabelObject():GetLabel())
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil):RandomSelect(tp,1)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and Duel.Damage(1-tp,1000,REASON_EFFECT)>0 then
		local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if e:GetLabel()>0 and #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rc=rg:Select(tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
			if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0
				and rc:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_FIRE)
				and rc:GetOriginalType()&TYPE_MONSTER>0
				and rc:GetOriginalLevel()>0 then
				Duel.Damage(1-tp,rc:GetOriginalLevel()*200,REASON_EFFECT)
			end
		end
	end
end
