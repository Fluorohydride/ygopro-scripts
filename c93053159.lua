--白の枢機竜
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,68468459)
	aux.AddMaterialCodeList(c,68468459)
	--aux.AddFusionProcCodeFun(c,68468459,s.mfilter,6,true,true)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(s.Alba_System_Drugmata_Fusion_Condition())
	e0:SetOperation(s.Alba_System_Drugmata_Fusion_Operation())
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_COST)
	e3:SetCost(s.atcost)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.tgcon)
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
end
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.Alba_System_Drugmata_Fusion_Filter(c,mg,fc,tp,chkf,gc)
	if not c:IsFusionCode(68468459) and not c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then return false end
	local g=mg:Filter(s.matfilter,c,tp)
	aux.GCheckAdditional=aux.dncheck
	local res=g:CheckSubGroup(s.Alba_System_Drugmata_Fusion_Gcheck,6,6,fc,tp,c,chkf,gc)
	aux.GCheckAdditional=nil
	return res
end
function s.matfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and not c:IsHasEffect(6205579)
end
function s.Alba_System_Drugmata_Fusion_Gcheck(g,fc,tp,ec,chkf,gc)
	local sg=g:Clone()
	sg:AddCard(ec)
	if sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if gc and not sg:IsContains(gc) then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc)
		or aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,sg,fc) then return false end
	return g:GetClassCount(Card.GetFusionCode)==g:GetCount()
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function s.Alba_System_Drugmata_Fusion_Condition()
	return function(e,g,gc,chkf)
			if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
			local fc=e:GetHandler()
			local tp=e:GetHandlerPlayer()
			if gc then
				if not g:IsContains(gc) then return false end
				return g:IsExists(s.Alba_System_Drugmata_Fusion_Filter,1,nil,g,fc,tp,chkf,gc)
			end
			return g:IsExists(s.Alba_System_Drugmata_Fusion_Filter,1,nil,g,fc,tp,chkf,nil)
		end
end
function s.Alba_System_Drugmata_Fusion_Operation()
	return function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
			local fc=e:GetHandler()
			local tp=e:GetHandlerPlayer()
			local fg=eg:Clone()
			local g=nil
			local sg=nil
			while not sg do
				if g then
					fg:AddCard(g:GetFirst())
				end
				if gc then
					if s.Alba_System_Drugmata_Fusion_Filter(gc,fg,fc,tp,chkf) then
						g=Group.FromCards(gc)
						fg:RemoveCard(gc)
						local mg=fg:Filter(s.matfilter,fc,tp)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						sg=mg:SelectSubGroup(tp,s.Alba_System_Drugmata_Fusion_Gcheck,false,6,6,fc,tp,g:GetFirst(),chkf,gc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						g=fg:FilterSelect(tp,s.Alba_System_Drugmata_Fusion_Filter,1,1,nil,fg,fc,tp,chkf,gc)
						fg:Sub(g)
						local mg=fg:Filter(s.matfilter,fc,tp)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						sg=mg:SelectSubGroup(tp,s.Alba_System_Drugmata_Fusion_Gcheck,true,6,6,fc,tp,g:GetFirst(),chkf,gc)
					end
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					g=fg:FilterSelect(tp,s.Alba_System_Drugmata_Fusion_Filter,1,1,nil,fg,fc,tp,chkf,nil)
					fg:Sub(g)
					local mg=fg:Filter(s.matfilter,fc,tp)
					aux.GCheckAdditional=aux.dncheck
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					sg=mg:SelectSubGroup(tp,s.Alba_System_Drugmata_Fusion_Gcheck,true,6,6,fc,tp,g:GetFirst(),chkf)
					aux.GCheckAdditional=nil
				end
			end
			g:Merge(sg)
			Duel.SetFusionMaterial(g)
		end
end
function s.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function s.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
end
function s.cfilter(c)
	return aux.IsMaterialListCode(c,68468459)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
		and g:GetClassCount(Card.GetCode)>5
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
